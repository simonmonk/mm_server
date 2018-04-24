class OrderIn < ApplicationRecord
  belongs_to :supplier
  has_many :order_in_lines
    
    
  # generate unique invoice number in format YYYYMMDDnn
  def order_number
    if (not self.id)
        return "save to allocate number"
    end
    base = Time.new().strftime("%Y")
    return base + "_" + self.id.to_s
  end

  # todo, if the part is not supplied by this supplier yet, then add part_supplier and record    
  # add a part order line to the order_in
  def add_order_line(part_id, qty, price)
    part = Part.find(part_id)
    old_price = part.cost
    part.cost = price
    part.save
    order_line = nil
    results = OrderInLine.where(order_in_id: self.id, part_id: part_id)
    if (results.length > 0)
        order_line = results[0]
        order_line.qty = qty 
        order_line.qty_in = 0
        order_line.price = price
        order_line.save
    else
        order_line = OrderInLine.new(:order_in_id => self.id, :part_id => part_id, :qty => qty, :qty_in => 0, :price => price)
        order_line.save
    end
    supplier_id = order_line.order_in.supplier.id
    results = PartSupplier.where(part_id: part_id, supplier_id: supplier_id)
    if (results.length == 0)
        part_supplier = PartSupplier.new(:part_id => part_id, :supplier_id => supplier_id)
        puts "**********Made new partsupplier************"
        puts "**********************"
        part_supplier.save
    end
    if (old_price.round(2) != price.round(2)) 
        t = Transaction.new
        t.transaction_type = 'Part cost change'
        t.description = "Part " + part.name + " changed price from " + old_price.to_s + " to " + price.to_s +
          " as a result of order (goods in) from " + order_line.order_in.supplier.name 
        t.save
    end
  end       
    
  def summary()
      num_items = self.order_in_lines.length
      if (num_items == 0) 
          return "nothing"
      end
      first_item = self.order_in_lines[0]
      first_name = "deleted part"
      if (first_item.part)
          first_name = first_item.part.name
      end
      if (num_items == 1)
         return first_item.qty.to_s + " x " + first_name  
      end
      if (num_items == 2)
          return first_item.part.name + " and one other item."
      end
      return first_item.part.name + " and " + (num_items - 1).to_s + " other items."
  end
    
        
  def complete?()
     complete = true
     self.order_in_lines.each do |line|
         puts "**********" + line.qty.to_s + " " + line.qty_in.to_s + "************"
          if (line.qty <= line.qty_in)
              complete = false
          end
     end
    return complete
  end



  def priced?()
     priced = true
     self.order_in_lines.each do |line|
          if (not line.price or line.price == 0)
              priced = false
          end
     end
    return priced
  end
    
  def priority()
    if (self.complete?)
        return 12 # Complete - green
    end
    if (self.priced?)
        return 13 # Oustanding - red
    else
        return 11 # In progress (unpriced) - black
    end
  end
    
    
end
