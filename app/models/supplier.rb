class Supplier < ApplicationRecord
    has_many :part_suppliers
    has_many :order_ins
    
    validates :name, presence: true
    
    
    def fastest_delivery()
        min_days = 999
        self.order_ins.each do |order|
            t0 = order.placed_date
            order.order_in_lines.each do | line |
                t1 = line.date_line_received
                if (t0 and t1)
                    t = (t1 - t0).to_i
                    if (t < min_days) 
                        min_days = t
                    end
                end
            end
        end
        if (min_days < 999)
            return min_days
        else
            return 0
        end
    end
    
    
end
