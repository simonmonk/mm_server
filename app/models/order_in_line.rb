class OrderInLine < ApplicationRecord
    belongs_to :order_in
    belongs_to :part, optional: true
    belongs_to :book_keeping_category, optional: true

    # find every OrderInLine withput a cost center and assign it to MAN
    # find every uncategorzed expense and assign it to PAR
    def fix_uncategorized()
        all.each do | line |
            if (not line.cost_centre)
                line.cost_centre = CostCentre.MAN
            end
            if (not line.book_keeping_category)
                line.book_keeping_category = BookKeepingCategory.PAR
            end
        end
    end

    def part_name()
        if (part)
            return part.name
        else
            if (description)
                return description
            else
                return "-"
            end
        end
    end

    def purchase_history()
        if (part)
            return part.purchase_history
        else
            return []
        end
    end

    def purchase_cost_today()
        if (part)
            return part.purchase_cost_today
        else
            return 0
        end
    end

    def part_qty()
        if (part)
            return part.qty
        else
            return 0
        end
    end

    
    def as_json(options={})
        super(:methods => [:part, :part_name, :purchase_history, :purchase_cost_today, :part_qty])
    end  

end
