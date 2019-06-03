class Supplier < ApplicationRecord
    has_many :part_suppliers
    has_many :order_ins
    
    validates :name, presence: true
    
    def Supplier.tax_regions()
        return ['UK', 'EU', 'Rest of the World']
    end

    def parts()
        parts = []
        part_suppliers.each do | ps | 
            if (ps.part)
                parts.push(ps.part)
            else
                # part_supplier has no part (presumably deleted)
                # so delete the part_supplier too
                ps.delete
            end
        end
        return parts
    end
    
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


    
    def as_json(options={})
        super(:methods => [:parts])
    end  
    
end
