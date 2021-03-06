class Assembly < ApplicationRecord
    has_many :assembly_parts
    has_many :product_assemblies
    belongs_to :assembly_category
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 } 
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 } 
    
    def stock_name
        return 'ASS-' + id.to_s.rjust(6, "0")
    end

    # return all the Active assemblies
    # sorted alphabeticaly for use in lists
    def Assembly.active_assemblies
        Assembly.all.where(active: true).order(name: :asc)
    end

    def production_cost
        total = 0
        self.assembly_parts.each do | pp |
            total += pp.part.purchase_cost * pp.qty
        end
        if (self.labour)
            total += self.labour
        end
        if (uses_panel)
            panel = Assembly.find(parent_assembly_id)
            total += panel.production_cost
        end
        return total
    end

    def calculated_labour_cost
        if (not build_time_mins || build_time_mins == 0)
            return 0
        else
            hourly_rate = Setting.get_setting('HOURLY_RATE')
            pounds_per_min = hourly_rate.to_f / 60.0
            if (is_panel and panel_num_boards and panel_num_boards > 0)
                return (pounds_per_min * build_time_mins / panel_num_boards).round(2)
            else
                return (pounds_per_min * build_time_mins).round(2)
            end
        end
    end
    
    def possible_makes
        big_number = 100000000000000
        n = big_number
        self.assembly_parts.each do |ap|
            if (ap.qty > 0)
                stock_to_needed = (ap.part.qty / ap.qty).to_i()
                if (stock_to_needed < n)
                    n = stock_to_needed
                end
            end
        end
        # for assemblies that are made from a panel
        if (parent_assembly_id and parent_assembly_id > 0)
            panel_assembly = Assembly.find(parent_assembly_id)
            n_boards = panel_assembly.qty * panel_assembly.panel_num_boards
            if (n_boards < n)
                n = n_boards
            end
        end
        if (is_panel and panel_num_boards)
            return n / panel_num_boards
        end
        # nothing constrained show show a sensible number
        if (n == big_number)
            return 0
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

    def is_panel
        if (assembly_category)
            return assembly_category.is_panel
        end
        return false
    end

    def uses_panel
        return (parent_assembly_id and parent_assembly_id > 0)
    end

    # The panel which this bagged PCB uses
    def panel
        Assembly.find_by_id(parent_assembly_id)
    end

    # The bagged PCB in which this panel is used
    def bagged_pcb
        Assembly.find_by_parent_assembly_id self.id
    end

    def Assembly.panel_assemblies
        assemblies = [Assembly.new(name: 'NONE', id: 0)]
        Assembly.active_assemblies.each do | ass |
            if (ass.is_panel)
                assemblies.append(ass)
            end
        end
        return assemblies
    end

    def as_json(options={})
        super(:methods => [:possible_makes, :is_panel])
    end  
    
end
