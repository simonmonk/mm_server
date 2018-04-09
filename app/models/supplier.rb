class Supplier < ApplicationRecord
    has_many :part_suppliers
    has_many :order_ins
    
    validates :name, presence: true
    
    
    def fastest_delivery()
        min_time = 999
        self.order_ins.each do |order|
            t0 = order.placed_date
                puts "*******************"
                puts order.order_in_lines.length
            order.order_in_lines do | line |
                t1 = line.updated_at
                puts "***"
                if (t0 and t1)
                    t = t1 - t0
                    if (t < min_time) 
                        min_time = t
                    end
                end
            end
        end
        if (min_time < 999)
            return min_time
        else
            return 0
        end
    end
    
    
end
