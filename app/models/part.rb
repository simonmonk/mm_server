class Part < ApplicationRecord
    has_many :product_parts
    has_many :assembly_parts
    has_many :part_suppliers
    belongs_to :part_category
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 }
    validates :cost, presence: true
    
    
    # return all the Active parts
    # sorted alphabeticaly for use in lists
    def Part.active_parts
        Part.all.where(active: true).order(name: :asc)
    end
    
    def purchase_cost_all_stock
        if (self.qty)
            return self.purchase_cost * self.qty
        end
        return 0
    end
    
    def purchase_cost
        if (self.active && self.cost)
            if (self.currency == "GBP")
                return self.cost
            elsif (self.exch_rate)
                return self.cost / self.exch_rate
            end
        end
        return 0
    end
    
    def purchase_cost_with_shipping
        base_cost = self.purchase_cost
        if (self.shipping_cost)
            return base_cost + self.shipping_cost
        else
            return base_cost
        end
    end
    
    def Part.total_value
        total = 0
        Part.all.each do |part|
            total += part.purchase_cost_all_stock
        end
        return total
    end
    
end
