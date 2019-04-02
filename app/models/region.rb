class Region < ApplicationRecord

    has_many :retailers

    def wholesale_customers()
        retailers.select { | retailer | not retailer.is_retail }
    end

end
