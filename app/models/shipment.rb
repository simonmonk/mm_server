class Shipment < ApplicationRecord
  belongs_to :retailer
  has_many :shipment_products, :dependent => :destroy
    
  validates :invoice_number, uniqueness: true, if: 'invoice_number.present?'
    
  # width, height, depth should have been:
  # length, width, height
  # - so remap them in UI, or its a data nightmare

  def is_amazon()
    return (retailer and retailer.name.upcase().starts_with?('AMAZON'))
  end

  def is_new()
    return (not date_dispatched or date_dispatched > Date.current)
  end

  def is_unpaid()
    return (not is_paid() and not is_amazon())
  end

  def is_paid()
    return (date_payment_received and (date_payment_received <= Date.current))
  end

  def is_overdue()
    return (is_unpaid() and date_payment_reminder and Date.current > date_payment_reminder and not is_amazon())
  end


  ################### deprecated ###################
  def paid?()
      return (date_payment_received and date_payment_received <= Date.current)
  end
    
  def priority()
    if (self.paid?)
        return "Paid"   # Paid and complete - black
    end
    if (not date_invoice_sent)
        return "InProgress"   # In progress - blue
    end
    if (date_payment_reminder and Date.current < date_payment_reminder)
        return "AwaitingPayment"    # Awaiting payment - green
    else
        return "Overdue"    # Overdue - red
    end
  end
  ################### deprecated ###################


  # generated each time a quotation is created - allows saving of PDF quotes with this number in the file name
  def quotation_number()
    return Time.new().strftime("Q%Y%m%d%I%M")
  end

    
  def total_invoice_amount()
    sales_total = 0
    lines = self.shipment_products
    lines.each do | line |
      if (line.price)
        sale = line.qty * line.price
        sales_total += sale
      else
        line.delete # delete orphaned lines
      end
    end
    if (shipping_cost)
        sales_total += shipping_cost
    end
    if (discount)
      sales_total -= discount
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
    
  def Shipment.create_from_forwarded_email(email_body)
    my_addr = Socket.ip_address_list.detect(&:ipv4_private?).try(:ip_address) + ":3000"
    matches = email_body.match(/<(.*)>/)
    if (matches and matches.length > 0)
        retailer_email = matches[1]
        retailer_domain = retailer_email.match(/@(\S*)/)[1]
        retailer = Retailer.with_domain(retailer_domain)
        if (retailer)
            shipment = Shipment.new
            shipment.retailer = retailer
            shipment.date_order_received = Date.current()
            shipment.shipping_provider = retailer.pref_shipping_provider
            shipment.shipping_provider_ac_no = retailer.pref_shipping_provider_ac_no 
            shipment.order_email = email_body
            shipment.save
            return "ORDER CREATED for " + retailer.name + ". View Order " + "<a href='http://" + my_addr + "/shipments/" + shipment.id.to_s + "/edit'>here</a>"
        else
            return "NO ORDER CREATED: can't find a retailer with the domain: " + retailer_domain + "."
        end
    else
        return "NO ORDER CREATED: email does not appear to be forwarded from a customer."
    end
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

# for json interface

def retailer_name
  return self.retailer.name
end
    
end
