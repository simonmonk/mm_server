class Shipment < ApplicationRecord
  belongs_to :retailer
  belongs_to :account
  has_many :shipment_products, :dependent => :destroy
    
  validates :invoice_number, uniqueness: true, if: 'invoice_number.present?'
    
  # width, height, depth should have been:
  # length, width, height
  # - so remap them in UI, or its a data nightmare

  def is_amazon()
    return (retailer and retailer.name.upcase().starts_with?('AMAZON'))
  end

  def is_new()
    return (not date_dispatched or date_dispatched > Date.current and not is_cancelled)
  end

  def is_unpaid()
    return (not is_paid() and not is_new())
  end

  def is_paid()
    return (date_payment_received and (date_payment_received <= Date.current))
  end

  def is_overdue()
    return (is_unpaid() and date_payment_reminder and Date.current > date_payment_reminder and not is_amazon())
  end


  # This set of methods are mirrored in OrderIn and provide a polymorphic view of account transactions
  #
  #

  # accounting date on accrual basis (invoice sent not necessarily paid) for polymorphism
  
  def transaction_type()
    return 'SHIPMENT'
  end
  
  def accounting_date()
    return cash_date()
  end

  def accrual_date()
    return date_invoice_sent
  end

  def cash_date()
    return date_payment_received
  end

  def accounts()
    if (account_id)
      return account.name
    else
      return '?'
    end
  end

  def transaction_summary()
    'Sale to ' + retailer.name
  end

  def direction()
    return 'MONEY_IN'
  end

  def account_ids()
    return [account.id]
  end

  def organisation()
    if (retailer)
      return retailer.name
    else
      return "error id=" + id.to_s
    end
  end

  def description()
    num_items = self.shipment_products.length
    if (num_items == 0) 
        return "nothing"
    end
    first_item = self.shipment_products[0]
    first_name = ""
    if (first_item.product)
        first_name = first_item.product.name
    end
    if (num_items == 1)
       return first_item.qty.to_s + " x " + first_name  
    end
    if (num_items == 2)
        return first_name + " and one other item."
    end
    return first_name + " and " + (num_items - 1).to_s + " other items."
  end

  def category()
    return "Sale"
  end

  def is_income()
    return true
  end

  # not part of the polymorphism but a utility fn.
  def sales_from_invoice()
    sales_total = 0
    lines = self.shipment_products
    lines.each do | line |
      if (line.price)
        sale = line.qty * line.price
        sales_total += sale
      end
    end
    if (shipping_cost)
        sales_total += shipping_cost
    end
    if (discount)
      sales_total -= discount
    end
    return sales_total
  end

  def without_vat() # currency ignored
    # return sales_from_invoice()
    if (total_invoice_collected)
      return total_invoice_collected - vat()
    else
      return 0
    end
  end

  def vat()
    vat = 0
    if (vat_rate and retailer.vatable == true)
      vat = sales_from_invoice() * vat_rate / 100
    end
    return vat
  end

  def with_vat()
    return total_invoice_collected 
  end

  def tax_region()
    return retailer.tax_region
  end

  def is_vatable()
    return true
  end

  def is_service()
    return false
  end

  def is_adjustment()
    return false
  end

  def is_order_in()
    return false
  end

  def is_shipment()
    return true
  end

  def has_proof_uploaded()
    return true
  end


  # shipments are always invoiced in pounds (apart from Eduporium)

  def without_vat_original_currency()
    return without_vat
  end

  def vat_original_currency()
    return vat
  end

  def with_vat_original_currency()
    return with_vat
  end

  def currency()
    if (retailer.pref_currency)
      return retailer.pref_currency
    else
      return 'GBP'
    end
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

  def Shipment.monthly_sales()
    year = Date.today().year
    this_year_sales = []
    last_year_sales = []
    year_before_last_sales = []
    
    1.upto 12 do | month |
      month_start_this_year = Date.new(year, month, 1)
      month_end_this_year = month_start_this_year.end_of_month
      month_start_last_year = Date.new(year-1, month, 1)
      month_end_last_year = month_start_last_year.end_of_month
      month_start_year_before_last = Date.new(year-2, month, 1)
      month_end_year_before_last = month_start_year_before_last.end_of_month
      this_year_sales.append(Shipment.invoiced_sales_profit(month_start_this_year, month_end_this_year)[0])
      last_year_sales.append(Shipment.invoiced_sales_profit(month_start_last_year, month_end_last_year)[0])
      year_before_last_sales.append(Shipment.invoiced_sales_profit(month_start_year_before_last, month_end_year_before_last)[0])
    end
    return [this_year_sales, last_year_sales, year_before_last_sales]
  end

  def Shipment.sales_by_product_top_n(days, n)
    product_names = []
    sales = []
    units = []
    prods = Shipment.sales_by_product(days)[0..n-1]
    prods.each do | prod |
      product_names.append(prod['name'])
      sales.append(prod['sales'])
      units.append(prod['units'])
    end
    return [product_names, sales, units]
  end

  def Shipment.sales_by_product(days)
    start_date = Date.today-days
    end_date = Date.today
    sales_list = [] # list of {product_name => sales}
    Product.all.each do | p |
      if (p.active)
        units_and_value = p.units_and_value_shipped(start_date, end_date)
        units = units_and_value[0].to_i
        sales = units_and_value[1].to_i
        sales_list.append({'name' => p.name, 'sales' => sales, 'units' => units})
      end
    end
    sales_list = sales_list.sort_by { | product | product['sales'] }.reverse
    return sales_list
  end

  def Shipment.sales_by_customer_top_n(days, n)
    customer_names = []
    sales = []
    custs = Shipment.sales_by_customer(days)[0..n-1]
    custs.each do | cust |
      customer_names.append(cust['name'])
      sales.append(cust['sales'])
    end
    return [customer_names, sales]
  end

  def Shipment.sales_by_region(days)
    start_date = Date.today-days
    end_date = Date.today
    totals = {}
    shipments = Shipment.where("date_order_received >= :start_date AND date_order_received <= :end_date", {start_date: start_date, end_date: end_date})
    shipments.each do | shipment |
      region = shipment.retailer.region.name
      if (not totals[region])
        totals[region] = shipment.without_vat()
      else
        totals[region] += shipment.without_vat()
      end
    end
    return [totals.keys, totals.values]
  end

  def Shipment.sales_by_country(days)
    start_date = Date.today-days
    end_date = Date.today
    totals = {}
    shipments = Shipment.where("date_order_received >= :start_date AND date_order_received <= :end_date", {start_date: start_date, end_date: end_date})
    shipments.each do | shipment |
      country = shipment.retailer.billing_ad_country
      if (not totals[country])
        totals[country] = shipment.without_vat()
      else
        totals[country] += shipment.without_vat()
      end
    end
    return [totals.keys, totals.values]
  end

  def Shipment.sales_by_customer(days)
    start_date = Date.today-days
    end_date = Date.today
    sales_list = [] # list of {product_name => sales}
    Retailer.all.each do | r |
      if (r.active)
        sales = r.units_and_value_shipped(start_date, end_date).to_i
        sales_list.append({'name' => r.name, 'sales' => sales})
      end
    end
    sales_list = sales_list.sort_by { | customer | customer['sales'] }.reverse
    return sales_list
  end

  # not used - monthly proved more useful
  # def Shipment.weekly_sales(from_date, to_date)
  #   week_starting = []
  #   value_total = []
  #   start_week = Sale.week_of_epoch(Time.parse(from_date.to_s))
  #   end_week = Sale.week_of_epoch(Time.parse(to_date.to_s))
  #   start_week.upto end_week do | week |
  #     start_of_week = Sale.date_for_week_of_epoch_formatted(week)
  #     week_starting.append(start_of_week)
  #     week_start_date = Sale.date_for_week_of_epoch(week)
  #     week_end_date = Sale.date_for_week_of_epoch(week + 1)
  #     # Is there overlap of shipmants here?
  #     value = Shipment.invoiced_sales_profit(week_start_date, week_end_date)[0]
  #     value_total.append(value)
  #   end
  #   return [week_starting, value_total]
  # end

  def Shipment.invoiced_sales_profit(start_date, end_date)
    shipments = Shipment.where("date_order_received >= :start_date AND date_order_received <= :end_date", {start_date: start_date, end_date: end_date})
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
        retailer_domain_search = retailer_email.match(/@(\S*)/)
        if (retailer_domain_search and retailer_domain_search.length > 1)
          retailer_domain = retailer_domain_search[1]
          retailer = Retailer.with_domain(retailer_domain)
          if (retailer)
              shipment = Shipment.new
              shipment.retailer = retailer
              shipment.date_order_received = Date.current()
              shipment.invoice_number = Shipment.find_next_invoice_number()
              shipment.shipping_provider = retailer.pref_shipping_provider()
              shipment.shipping_provider_ac_no = retailer.pref_shipping_provider_ac_no 
              shipment.order_email = email_body
              shipment.vat_rate = 20
              shipment.save
              return "ORDER CREATED for " + retailer.name + ". View Order " + "<a href='http://" + my_addr + "/shipments/>here</a>"
          else
              return "NO ORDER CREATED: can't find a retailer with the domain: " + retailer_domain + "."
          end
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

  def as_json(options={})
    super(:methods => [:retailer_name, :total_invoice_amount, :is_amazon, :is_new, :is_unpaid, :is_paid, :is_overdue, :shipment_products, :retailer,
                        :without_vat, :vat, :with_vat, :accounting_date, :transaction_type, :accounts, :transaction_summary, :direction,
                        :account_ids, :has_proof_uploaded])
  end
    
end
