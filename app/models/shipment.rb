class Shipment < ApplicationRecord
  belongs_to :retailer
  has_many :shipment_products
    
  validates :invoice_number, uniqueness: true, if: 'invoice_number.present?'
    

  def paid?()
      return (date_payment_received and date_payment_received <= Date.current)
  end
    
  def priority()
    if (self.paid?)
        return 11   # Paid and complete - black
    end
    if (not date_invoice_sent)
        return 10   # In progress - blue
    end
    if (date_payment_reminder and Date.current < date_payment_reminder)
        return 12    # Awaiting payment - green
    else
        return 13    # Overdue - red
    end
  end

  # generated each time a quotation is created - allows saving of PDF quotes with this number in the file name
  def quotation_number()
    return Time.new().strftime("Q%Y%m%d%I%M")
  end

    
  def total_invoice_amount()
    sales_total = 0
    lines = self.shipment_products
    lines.each do | line |
      sale = line.qty * line.product.wholesale_price
      sales_total += sale
    end
    if (shipping_cost)
        sales_total += shipping_cost
    end
    if (vat_rate and retailer.vatable == true)
        vat = sales_total * vat_rate / 100
        sales_total += vat
    end
    return sales_total
  end

    
    
  def total_value_profit_gbp()
    sales_total = 0
    profit_total = 0
    currency = self.retailer.pref_currency
    lines = self.shipment_products
    lines.each do | line |
      sale = line.qty * line.product.wholesale_price
      if (currency == 'USD')
        sale = sale / Currency.dollars_per_pound
      end
      sales_total += sale
      profit = line.qty * line.product.profit
      profit_total += profit
    end
    return [sales_total.to_i, profit_total.to_i]
  end


  def Shipment.invoiced_sales_profit(start_date, end_date)
    shipments = Shipment.where("date_order_received >= :start_date AND date_order_received < :end_date", {start_date: start_date, end_date: end_date})
    sales_total = 0
    profit_total = 0
    shipments.each do | shipment |
      sales_and_profits = shipment.total_value_profit_gbp
      sales_total += sales_and_profits[0]
      profit_total += sales_and_profits[1]
    end
    return [sales_total, profit_total]
  end
   
    
  # generate unique invoice number in format YYYYMMDDnn
  def Shipment.find_next_invoice_number()
    base = Time.new().strftime("%Y%m%d")
    i = 1
    candidate = base + (i<10?"0"+i.to_s():i.to_s())
    while (i < 100 and Shipment.where(invoice_number: candidate).length > 0) do
        candidate = base + (i<10?"0"+i.to_s():i.to_s())
        i = i + 1
    end
    if (i >= 99)
        return "all 99 invoice slots taken for today"
    else
        return candidate
    end
  end
    
end
