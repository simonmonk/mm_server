class Adjustment < ApplicationRecord
  
  def from_account()
    return Account.find_by_id(from_account_id)
  end

  def to_account()
    return Account.find_by_id(to_account_id)
  end

  def account()
    return from_account()
  end

  def Adjustment.amazon_countries()
    return ['UK', 'USA', 'FR', 'DE', 'IT', 'ES', 'NL']
  end

  def Adjustment.amazon_eu_countries()
    return ['FR', 'DE', 'IT', 'ES', 'NL']
  end

  def Adjustment.region_for_country(country)
    if (country == 'UK')
      return 'UK'
    elsif (country == 'USA')
      return Supplier.tax_regions().last # Rest of World
    else
      return 'EU'
    end
  end


  def Adjustment.amazon_months()
    months = []
    today = Time.now
    current_month_num = today.month
    year = today.year
    for i in 0..11 do
      month_num = current_month_num - i
      if (month_num < 1)
        month_num = current_month_num + 12 - i
        year = today.year - 1
      end
      month_name = Date::MONTHNAMES[month_num] + ' ' + year.to_s
      months.append({name: month_name, date: Date.new(year, month_num, 1).iso8601})
    end
    return months
  end

  # belongs_to :adjustment_type // nope cant do this beacuse of migration of string adjustment type to an object.

    # THIS IS NOW IN SEPARATE ADJUSTMENT_TYPE OBJEVT - DELETE THIS !!!!!!!!!!!!!!!!!!!!!!!
    # def Adjustment.types()
    #     return ['Overpayment', 'Underpayment', 'Transfer', 'Actual Income from Amazon', 'Reported Income from Amazon', 
    #               'Amazon Fees', 'HMRC Adjustment', 'Ebay Sale', 'Reimbursement'] # Add but dont edit!
    # end

  # for polymorphism using orders_in and shipments

  def transaction_summary()
    result = 'Adjustment ' + adj_type().name
    if (adj_type.code == 'AMAZON_REPORTED' or adj_type.code == 'AMAZON_FEES')
      result += ' (' + description + ')'
    end
    return result
  end

  def adj_type()
    return AdjustmentType.find(adjustment_type_id)
  end

  def name()
    'ADJ-' + id.to_s
  end

  def Adjustment.migrate_accounts()
    Adjustment.all.each do | adjustment |
      # can't use relation to adjustment_type, as it may be a string
      adj_type = AdjustmentType.find(adjustment.adjustment_type_id)
      if (not adj_type)
        puts "Adjustment not set for adjustment:" + adjustment.id.to_s + " adjustment_type string:" + adjustment.adjustment_type
        puts "Run: AdjustmentType.migrate_string_adjustment_types()"
      end
      acc = adj_type.default_account()
      # put in a check that there is an adj_type, or you will need to convert it from a string.
      if (acc)
        puts "Setting account of adjustment:" + adjustment.id.to_s + " to:" + acc.name
        adjustment.from_account_id
        adjustment.save()
      else
        puts "****** Manual Action Needed Cannot set account for adjustemnt:" + adjustment.id.to_s 
      end
    end
  end

  def direction()
    if (adjustment_type == 'Transfer')
      return 'NEUTRAL'
    elsif (value > 0)
      return 'MONEY_IN'
    else
      return 'MONEY_OUT'
    end
  end

  # TODO - make this use both accounts for transfer etc
  def account_ids()
    ids = []
    if (from_account_id)
      ids.append(from_account_id)
    end
    if (to_account_id)
      ids.append(to_account_id)
    end
    return ids
  end

  def transaction_type()
    return 'ADJUSTMENT'
  end

  def accounting_date()
    return cash_date()
  end

  def accrual_date()
    return adjustment_date
  end

  def cash_date()
    return adjustment_date
  end

  def accounts()
    if (adj_type().code == 'TRANSFER')
      if (from_account and to_account)
        return from_account.name + '>>>' + to_account.name
      else
        return "?"
      end
    else
      if (from_account)
        return from_account.name
      else
        return "?"
      end
    end
  end

  # this uses old adjustment type - fix
  def category()
    return adjustment_type
  end




  def is_income()
    if (value >= 0)
        return true
    else
        return false
    end
  end

  def without_vat() # sign ignored use type for direction of money movement
    if (value)
      if (value < 0)
        return -value
      else
        return value
      end
    else
      return 0
    end
  end

  def vat() # sign ignored use type for direction of money movement
    if (vat_value)
      if (vat_value < 0)
        return -vat_value
      else
        return vat_value
      end
    else
      return 0
    end
  end

  def with_vat()
    return without_vat + vat
  end

  def is_service()
    return false
  end

  def is_adjustment()
    return true
  end

  def is_order_in()
    return false
  end

  def is_shipment()
    return false
  end

  def is_transfer()
    return (adj_type.code == 'TRANSFER')
  end

  def spreadsheet_description()
    return description
  end

  # part of 'transaction' polymorth 
  # return a sparse array with the without_vat amount in the correct bookeeping column
  def spreadsheet_bank_payment_cols()
    if (adj_type.code == 'TRANSFER' and to_account.code == 'PPL')
      return ['', '', with_vat]
    elsif ((adj_type.code == 'TRANSFER' and to_account.code == 'CC'))
      return [ '', '', '', with_vat]
    elsif ((adj_type.code == 'TRANSFER' and to_account.code == 'SAVE'))
      return [ '', '', '', '', with_vat]
    end
    return []
  end

  def spreadsheet_bank_receipt_cols()
    # col I (Amazon) - Income received from Amazon (Adjustment) - either transfer from Amazon, or specific Amazon actual type (legacy)
    # col J (Interest) - HMRC Adjustment
    # adjustment underpayment - E.g Daisey part payment for CO2 sensors in advance - which COL?? depends on tax_region 
    if (adj_type.code == 'TRANSFER' and from_account.code == 'AM' and to_account.code == 'CUR')
      return ['', '', '', with_vat]
    elsif (adj_type.code == 'AMAZON_ACTUAL')
      return [ '', '', '', with_vat, '']
    elsif (adj_type.code == 'UNDER_PAYMENT' and from_account.code == 'CUR')
      puts " **** spreadsheet_bank_receipt_cols UNDERPAYMENT *****" + tax_region
      if (tax_region == 'UK')
        return [without_vat, '', '', '', '']
      elsif (tax_region == 'EU')
        return [ '', without_vat, '', '', '']
      else # rest of world - exempt 
        return [ '', '', without_vat, '', '']
      end
    elsif (adj_type.code == 'HMRC')
      return [ '', '', '', '', with_vat]
    end
    return []
  end

  def include_spreadsheet_bank_payments()
    return (from_account_id == Account.for_code('CUR').id and is_transfer())
  end

  def include_spreadsheet_rnd_payments()
    return false
  end  

  def spreadsheet_rnd_payment_cols()
    return []
  end

  def spreadsheet_cc_payment_cols()
    if (adj_type.code == 'TRANSFER' and to_account.code == 'CC')
      return ['', '', with_vat]
    end
    return []
  end

  def include_spreadsheet_paypal_gbp_payments()
    return (from_account_id == Account.for_code('PPL').id and is_transfer())
  end

  def spreadsheet_paypal_gbp_payment_cols()
    return []
  end

  def include_spreadsheet_bank_receipts()
    return (
      # (adj_type.code == 'TRANSFER' and from_account.code == 'AM' and to_account.code == 'CUR') or
      (adj_type.code == 'TRANSFER' and to_account.code == 'CUR') or
      (adj_type.code == 'AMAZON_ACTUAL') or
      (adj_type.code == 'HMRC') or
      (adj_type.code == 'UNDER_PAYMENT' and from_account.code == 'CUR')
    )
  end

  def include_spreadsheet_cc_payments()
    return (from_account_id == Account.for_code('CC').id and is_transfer())
  end

  def spreadsheet_paypal_gbp_payment_cols()
    return (from_account_id == Account.for_code('PPL').id and is_transfer())
  end

  def country()
    return tax_region
  end

  def invoice_number()
    return ''
  end

  def has_proof_uploaded()
    root_dir = Setting.get_setting('ROOT_DIR')
    file = Dir.glob(root_dir + '/public/adjustment_paperwork/' + name + '.pdf')
    return (file.length == 1)
  end


  def boxes()
    code = adj_type.code
    if (code == 'TRANSFER' or code == 'AMAZON_ACTUAL' or code == 'HMRC')
      return []
    elsif (code == 'OVER_PAYMENT' || code == 'UNDER_PAYMENT')
      return [1, 6]
    elsif (code == 'AMAZON_REPORTED' or code == 'EBAY')
      # treat the same way as a sale
      if (tax_region == 'EU')
        return [1, 6, 8]
      else
        return [1, 6]
      end
    elsif (code == 'AMAZON_FEES')
      return [2, 4, 7]
    elsif (code == 'REIMBURSEMENT')
      # ask Linda why 7 - prob only 7 if its a reimbursement for an EU purchase
      return [4, 7]
    elsif (code == 'REFUND')
      # VAT for a refund needs knocking off from original purchase - its a kind of negative purchase
      return [4, 7] # TBA - ask Linda
    else
      return []
    end
  end

  # may be redundant
  def is_vatable()
    # vatable_codes = ['Overpayment', 'Underpayment', 'Reported Income from Amazon', 'Amazon Fees', 'Ebay Sale'] 
    # return vatable_codes.include?(adjustment_type)
    return vat > 0
  end

  def currency()
    return "GBP"
  end

  def notes()
    return description
  end

  def as_json(options={})
    super(:methods => [ :without_vat, :vat, :with_vat, :accounting_date, :transaction_type, :accounts, :transaction_summary, :direction,
                      :account_ids, :name, :has_proof_uploaded])
  end

end
