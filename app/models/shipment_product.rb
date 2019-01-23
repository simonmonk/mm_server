class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product
    
    
  def wholesale_in_currency()
     if (shipment.retailer.name == 'amazon.com')
         if (product.retail_price_usd)
             return product.retail_price_usd
         else
             return 0
         end
     end
     if (shipment.retailer.pref_currency == 'USD')
         if (product.wholesale_price_usd)
             return product.wholesale_price_usd
         else
             return 0
         end
     end
     return product.wholesale_price
  end

    # Use the wholesale or retail price depending on is_retail on the retailer
    # is_retail indicates that customer pays retail price not wholesale price
    def invoice_price
        if (self.shipment.retailer.is_retail == true)
            return self.product.retail_price
        else
            return self.product.wholesale_price
        end
    end


    
end
