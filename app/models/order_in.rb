class OrderIn < ApplicationRecord
  belongs_to :supplier, optional: true
  belongs_to :account, optional: true
  has_many :order_in_lines, :dependent => :destroy

  # for filtering of order ins

  def is_not_ordered()
    if (placed_date)
        return false
    else
        return true
    end
  end 

  def is_ordered_not_received()
    return (not is_not_ordered() and not is_received())
  end

  def is_received()
    if (self.order_in_lines.length == 0)
        return false
    end
    self.order_in_lines.each do | line |
        if (line.qty > line.qty_in)
            return false
        end
    end
    return true
  end

  def supplier_name()
    if (supplier)
        return supplier.name
    else
        return nil
    end
  end



  # This set of methods are mirrored in Shipment and provide a polymorphic view of account transactions
  #
  #

  def transaction_type()
    return 'ORDER_IN'
  end

  def is_adjustment()
    return false
  end

  def is_order_in()
    return true
  end

  # accounting date on accrual basis (order placed not necessarily paid) for polymorphism
  def accrual_date()
    return placed_date
  end

  def cash_date()
    return date_payment_made
  end

  def organisation()
    if (supplier)
      return supplier.name
    else
      return "error id=" + id.to_s
    end
  end

  def description()
    return summary
  end

  def has_proof_uploaded()
    root_dir = Setting.get_setting('ROOT_DIR')
    file = Dir.glob(root_dir + '/public/invoices/' + order_number + '.pdf')
    return (file.length == 1)
  end


# OrderIns need to be expanded by orderInLines of a particular accounting category
# Actually for VAT they don't but for accounts spreadsheet generation, they will.
# But, there are some accounting categories that affect the VAT applicability
# so, if an Order_in only has one Line, use that line's category.
  def category()
    if (order_in_lines.length == 1)
      cat = order_in_lines[0].book_keeping_category
      if (cat)
        return cat.name
      else
        return "?"
      end
    else
      return "?"
    end
  end

  def is_income()
    return false
  end

  def without_vat()
    if (currency != 'GBP' and exch_rate)
      if (actually_paid_gbp)
        return actually_paid_gbp
      else
        puts("*************")
        puts(as_json())
        return 0
      end
    else
      return without_vat_original_currency()
    end
  end

  def vat()
    if (currency != 'GBP' and exch_rate)
      return vat_original_currency() / exch_rate
    else
      return vat_original_currency()
    end
  end

  def with_vat()
    if (currency != 'GBP' and exch_rate)
      # return with_vat_original_currency() / exch_rate
      if (actually_paid_gbp)
        return actually_paid_gbp
      else
        puts("****** Missing *******")
        puts(as_json())
        return 0
      end
    else
      return with_vat_original_currency()
    end
  end

  def tax_region()
    return supplier.tax_region
  end

  def is_vatable()
    if (order_in_lines.length == 1 and order_in_lines[0].book_keeping_category)
      return order_in_lines[0].book_keeping_category.is_vat_input_category() 
    else
      return true
    end
  end

  # orders in may be in any currency

  def without_vat_original_currency()
    return invoice_goods_ammout.to_f + shipping.to_f
  end

  def vat_original_currency()
    return invoice_vat_ammout.to_f
  end

  def with_vat_original_currency()
    return invoice_total_ammount.to_f
  end

  #
  #
  #
     
    
  # generate unique invoice number in format YYYYMMDDnn
  def order_number
    if (not self.id)
        return "save to allocate number"
    end
    base = Time.new().strftime("%Y")
    return base + "_" + self.id.to_s
  end

  def add_order_line(part_id, qty, price, description)
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
      else
        first_name = first_item.description
      end
      if (num_items == 1)
         return first_item.qty.to_s + " x " + first_name  
      end
      if (num_items == 2)
          return first_name + " and one other item."
      end
      return first_name + " and " + (num_items - 1).to_s + " other items."
  end
    
   # todo delete probably redundant
  def complete?()
     if (self.order_in_lines.length == 0)
         return false
     end
     self.order_in_lines.each do | line |
          if (line.qty < line.qty_in)
              return false
          end
     end
    return true
  end

   # todo delete probably redundant
  def priced?()
     priced = true
     if (self.order_in_lines.length == 0)
         return false
     end
     self.order_in_lines.each do |line|
          if (not line.price or line.price == 0)
              priced = false
          end
     end
    return priced
  end
       
  # todo delete probably redundant
  def priority()
    if (self.placed_date)
        if (self.complete?)
            return 11 # Complete
        else
            return 13 # Oustanding
        end
    else
        return 12 # In progress
    end
  end
    
  def as_json(options={})
    super(:methods => [:supplier, :order_in_lines, :supplier_name, :order_number, :summary, :is_not_ordered, :is_ordered_not_received, :is_received, :has_proof_uploaded ])
  end  

end
