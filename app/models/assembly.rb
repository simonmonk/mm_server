class Assembly < ApplicationRecord
    has_many :assembly_parts
    has_many :product_assemblies
    belongs_to :assembly_category
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 } 
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 } 
    
    def production_cost
        total = 0
        self.assembly_parts.each do |pp|
            total += pp.part.purchase_cost * pp.qty
        end
        if (self.labour)
            total += self.labour
        end
        return total
    end
    
    def possible_makes
        n = 100000000000000
        self.assembly_parts.each do |ap|
            stock_to_needed = (ap.part.qty / ap.qty).to_i()
            if (stock_to_needed < n)
                n = stock_to_needed
            end
        end
       return n
    end
    
    def Assembly.total_value
        total = 0
        Assembly.all.each do |ass|
            total += (ass.production_cost * ass.qty)
        end
        return total
    end

    def Assembly.assign_default_cat
        Assembly.all.each do |ass|
            ass.assembly_category_id = 1
            ass.save()
        end
    end
    
end
