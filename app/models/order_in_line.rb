class OrderInLine < ApplicationRecord
    belongs_to :order_in
    belongs_to :part

    
    def as_json(options={})
        super(:methods => [:part])
    end  

end
