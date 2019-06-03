class Part < ApplicationRecord
    has_many :product_parts
    has_many :assembly_parts
    has_many :part_suppliers
    belongs_to :part_category
    
    validates :name, presence: true
    # validates :qty, numericality: { greater_than_or_equal_to: 0 }
    # validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 }
    # validates :cost, presence: true
    
    
    # return all the Active parts
    # sorted alphabeticaly for use in lists
    def Part.active_parts
        Part.all.where(active: true).order(name: :asc)
    end
    
    def purchase_cost_all_stock
        if (self.qty)
            return self.purchase_cost_with_shipping * self.qty
        end
        return 0
    end
    
    def is_unused?
       return self.product_parts.length == 0 && self.assembly_parts.length == 0 
        #return false
    end
    
    def purchase_cost
        # exhange rate at time of purchase
        if (self.active && self.cost)
            if (self.currency == "GBP")
                return self.cost
            elsif (self.exch_rate)
                return self.cost / self.exch_rate
            end
        end
        return 0
    end

    def purchase_cost_today
        # exchange rate now
        if (self.active && self.cost)
            if (self.currency == "GBP")
                return self.cost
            elsif (self.exch_rate)
                return self.cost / Currency.dollars_per_pound
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
    
    # list of all products used in whether directly or via an assembly
    def products_used_in
        products = []
        self.product_parts.each do |pp|
            if (pp.product)
                products.append(pp.product)
            end
        end
        assemblies = self.assembly_parts.collect {|ap| ap.assembly }
        assemblies.each do | assembly |
            assembly.product_assemblies.each do | pa |
                if pa.product and pa.product.active
                    products.append(pa.product)
                end
            end
        end
        return products
    end
    
    def usage_summary()
      prods = self.products_used_in()
      num_items = prods.length
      if (num_items == 0) 
          return "nothing"
      end
      first_item = prods[0]
      if (num_items == 1)
         return first_item.name  
      end
      if (num_items == 2)
          return first_item.name + " and one other product."
      end
      return first_item.name + " and " + (num_items - 1).to_s + " other products."
  end

  def purchase_history()
    # Here we are adding arbitrary json to the json returned for the model
    # A useful trick
    purchases = OrderInLine.where(part_id: id)
    result = []
    purchases.each do | order_in_line |
        order = order_in_line.order_in
        if (order) 
            purchase = {
                date: order.placed_date,
                supplier: order.supplier_name,
                qty: order_in_line.qty,
                price: order_in_line.price,
                currency: order.currency
            }
            result.append(purchase)
        end
    end
    return result
  end

      
  def as_json(options={})
    super(:methods => [])
  end  
    
end
