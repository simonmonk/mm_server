class Adjustment < ApplicationRecord
  
  def from_account()
    return Account.find_by_id(from_account_id)
  end

  def to_account()
    return Account.find_by_id(to_account_id)
  end


  # belongs_to :adjustment_type // nope cant do this beacuse of migration of string adjustment type to an object.

    # THIS IS NOW IN SEPARATE ADJUSTMENT_TYPE OBJEVT - DELETE THIS !!!!!!!!!!!!!!!!!!!!!!!
    # def Adjustment.types()
    #     return ['Overpayment', 'Underpayment', 'Transfer', 'Actual Income from Amazon', 'Reported Income from Amazon', 
    #               'Amazon Fees', 'HMRC Adjustment', 'Ebay Sale', 'Reimbursement'] # Add but dont edit!
    # end

  # for polymorphism using orders_in and shipments

  def transaction_summary()
    'Adjustment ' + adj_type().name
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
    return [1, 2]
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
    if (adjustment_type == 'Transfer')
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

  def without_vat() # currency ignored
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

  def vat()
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

  def has_proof_uploaded()
    root_dir = Setting.get_setting('ROOT_DIR')
    file = Dir.glob(root_dir + '/public/adjustment_paperwork/' + name + '.pdf')
    return (file.length == 1)
  end

  # def tax_region()
  #   if (adjustment_type == 'Amazon Fees')
  #       return 'EU' # From Belgium in fact
  #   end
  #   # modify to make this state and add to UI for Adjustments
  #   return 'UK'
  # end

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
