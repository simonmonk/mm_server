class Product < ApplicationRecord
    has_many :product_parts
    has_many :product_assemblies
    has_many :product_retailers
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, presence: true
    validates :labour, presence: true
    
    
    
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
    
    def suggested_wholesale
        return self.production_cost * 1.4
    end
        
    def suggested_retail
    	if (! self.wholesale_price)
    		return 0
    	end
        return self.wholesale_price / (1 - 0.4) # 40% margin
    end
        
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
    
    def Product.total_value
        total = 0
        Product.all.each do |prod|
            total += (prod.production_cost * prod.qty)
        end
        return total
    end
end
