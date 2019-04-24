require "csv"

class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product

  def as_json(options={})
    super(:methods => [:product, :line_total])
  end
    
  # This is only used in quotes and can probably be deleted
  def wholesale_in_currency()
     if (shipment.retailer.name == 'amazon.com')
        # Amazon special case - Reinstate USD prices but label clearly as
         if (product.retail_price_usd)
             return product.retail_price_usd
         else
             return 0
         end
     end
     if (shipment.retailer.pref_currency == 'USD')
        if (product.retail_price_usd)
            return product.retail_price_usd
        else
            return 0
        end
     end
     return product.wholesale_price
  end

    # Use the wholesale or retail price depending on is_retail on the retailer
    # is_retail indicates that customer pays retail price not wholesale price
    # also for customers who are invoiced in USD use to convert GBP price to USD
    # The result of this method is copied to the price field on the sp when the sp is
    # added to the order
    def invoice_price
        if (not shipment.invoice_exch_rate)
            # All new shipments should have an exchange rate attached but for old orders do this
            shipment.invoice_exch_rate = 1.3
            shipment.save
        end
        basic_price = self.product.wholesale_price
        if (self.shipment.retailer.is_retail == true)
            basic_price = self.product.retail_price
        end
        if (shipment.retailer.pref_currency == 'USD')
            return (basic_price * shipment.invoice_exch_rate).round(2) # stupidity tax already applied
        end
        return basic_price
    end

    def line_total
        if (price && qty)
            return price * qty
        end
    end

    def ShipmentProduct.fix_missing_prices
        # id,shipment_id,product_id,qty
        CSV.foreach('data.csv') do |row|  
            id = row[0].to_i
            sp = ShipmentProduct.find_by_id(id)
            if (not sp)
                shipment_id = row[1].to_i
                shipment = Shipment.find_by_id(shipment_id)
                product_id = row[2].to_i
                product = Product.find_by_id(product_id)
                qty = row[3].to_i
                if (shipment and product)
                    sp = ShipmentProduct.new(shipment_id: shipment_id, product_id: product_id, qty: qty)
                    sp.price = sp.invoice_price
                    puts("missing sp id=" + id.to_s + " price set to:" + sp.price.to_s)
                    sp.save
                end
            end
        end
    end

    
end
