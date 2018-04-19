class OrderIn < ApplicationRecord
  belongs_to :supplier
  has_many :order_in_lines
    
    
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
    if (old_price.round(2) != price.round(2)) 
        t = Transaction.new
        t.transaction_type = 'Part cost change'
        t.description = "Part " + part.name + " changed price from " + old_price.to_s + " to " + price.to_s +
          " as a result of order (goods in) from " + order_line.order_in.supplier.name 
        t.save
    end
  end       
    
end
