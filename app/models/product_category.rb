class ProductCategory < ApplicationRecord
    
    has_many :products

    def active_products
        pp = self.products
        return pp.select { | a | a.active }
    end
    
    def as_json(options={})
        super(:methods => [:active_products])
    end  
end
