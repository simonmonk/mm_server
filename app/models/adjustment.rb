class Adjustment < ApplicationRecord

  # belongs_to :adjustment_type // nope cant do this beacuse of migration of string adjustment type to an object.

    # This needs refactoring to use AdjustmentType - the method could 
    def Adjustment.types()
        return ['Overpayment', 'Underpayment', 'Transfer', 'Actual Income from Amazon', 'Reported Income from Amazon', 
                  'Amazon Fees', 'HMRC Adjustment', 'Ebay Sale', 'Reimbursement'] # Add but dont edit!
    end

  # for polymorphism using orders_in and shipments

  def transaction_summary()
    'Adjustment ' + adjustment_type
  end

  def name()
    'ADJ-' + id.to_s
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
      return 'acc1->acc2'
    else
      return 'acc1'
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

  # def tax_region()
  #   if (adjustment_type == 'Amazon Fees')
  #       return 'EU' # From Belgium in fact
  #   end
  #   # modify to make this state and add to UI for Adjustments
  #   return 'UK'
  # end

  def is_vatable()
    vatable_codes = ['Overpayment', 'Underpayment', 'Reported Income from Amazon', 'Amazon Fees', 'Ebay Sale'] 
    return vatable_codes.include?(adjustment_type)
  end

  def currency()
    return "GBP"
  end

  def notes()
    return description
  end

  def as_json(options={})
    super(:methods => [ :without_vat, :vat, :with_vat, :accounting_date, :transaction_type, :accounts, :transaction_summary, :direction,
                      :account_ids])
  end

end
