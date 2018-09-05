class Product < ApplicationRecord
    has_many :product_parts
    has_many :product_assemblies
    has_many :product_retailers
    has_many :shipment_products
    
    belongs_to :product_category
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, presence: true
    validates :labour, presence: true
    
    
    has_attached_file :barcode, styles: { medium: "230x154>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :barcode, content_type: /\Aimage\/.*\z/
    
    # return all the Active products
    # sorted alphabeticaly for use in lists
    def Product.active_products
        Product.all.where(active: true).order(name: :asc)
    end
    
    # used as a local cache to indicate that the product is already sold by a retailer
    attr_accessor :local_scope
    
    # calculate the production cost by adding up the costs of all the parts and assemblies
    # finally add in the labor cost for the product. Note that assemblies will have their own
    # labour cost.
    def production_cost
        total = 0
        self.product_parts.each do |pp|
          if (pp.part)
            total += pp.part.purchase_cost_with_shipping * pp.qty
          else
            # No part on a pp means the pp should be garbage collected
            pp.delete()
          end
        end
        self.product_assemblies.each do |pp|
            total += pp.assembly.production_cost * pp.qty
        end
        if (self.labour)
            total += self.labour
        end
        return total
    end
    
    def units_and_value_shipped(start_date, end_date)
        #shipments = Shipment.where("date_order_received >= :start_date AND date_order_received < :end_date", {start_date: start_date, end_date: end_date})
        units_sold = 0
        value_sold = 0
        profit_total = 0
        self.shipment_products.each do | sp |
            if (sp.shipment)
                sp_date = sp.shipment.date_order_received
                if (sp_date and sp_date > start_date and sp_date <= end_date)
                    units_sold += sp.qty
                    value_sold += sp.wholesale_in_currency * qty
                    profit_total += sp.qty * sp.product.profit
                end
            end
        end
        return [units_sold, value_sold, profit_total]
    end
    
    def profit
        return [self.wholesale_price - self.production_cost, 0].max
    end

    # suggested wholesale price add 40% to manufacturing cost
    def suggested_wholesale
        return self.production_cost * 1.4
    end
    
    # Convert currency from todays exchange rate from GPB result
    def suggested_wholesale_usd
        return self.suggested_wholesale * Currency.dollars_per_pound
    end

    # suggested retail 40% gross margin for retailer on wholesale price
    def suggested_retail
    	if (! self.wholesale_price)
    		return 0
    	end
        return self.wholesale_price / (1 - 0.4) # 40% margin
    end
    
    # Convert currency from todays exchange rate from GPB result
    def suggested_retail_usd
        return self.suggested_retail * Currency.dollars_per_pound
    end

    # calculate the number of products that can be made constrained by
    # the numbers of parts and assemplies available
    def possible_makes
        n = 100000000000000
        self.product_parts.each do |pp|
            stock_to_needed = (pp.part.qty / pp.qty).to_i()
            if (stock_to_needed < n)
                n = stock_to_needed
            end
        end
        self.product_assemblies.each do |pa|
            stock_to_needed = (pa.assembly.qty / pa.qty).to_i()
            if (stock_to_needed < n)
                n = stock_to_needed
            end
        end
       return n
    end

    # find a prpduct by SKU with some fancy processing rules for
    # Amazon skus needed for integration with Amazon API
    def Product.lookup_sku(sku)
        product = Product.find_by_sku(sku)
        if (product)
            return product
        elsif (sku.downcase.ends_with?('fba'))
            # amazon /.com may have FBA on the end of the SKU, so chop it off
            short_sku = sku[0..-4]
            product = Product.find_by_sku(short_sku)
            if (product)
                return product
            end
        end
        return nil
    end

    # Total value of all products in the system
    def Product.total_value
        total = 0
        Product.all.each do |prod|
            total += (prod.production_cost * prod.qty)
        end
        return total
    end

    # deduct quatities of all the parts and assemblies used for n of this product.
    def deduct_stock(n)
        self.product_parts.each do |pp|
            pp.part.qty = pp.part.qty - pp.qty * n
            pp.part.save
        end
        self.product_assemblies.each do |pp|
            pp.assembly.qty = pp.assembly.qty - pp.qty * n
            pp.assembly.save
        end
        self.qty = self.qty + n
        self.save
        t = Transaction.new
        t.transaction_type = 'Deduct Stock for Product'
        t.description = "Removed parts and assemblies from stock to make " + n.to_s + " new " + self.name
        t.save
    end
    
    def Product.last_barcode
        bc = 0
        Product.all.each do |prod|
            if (prod.barcode_value.to_i > bc)
                bc = prod.barcode_value.to_i
            end
        end 
        return bc
    end

end
