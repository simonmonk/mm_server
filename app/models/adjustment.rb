class Adjustment < ApplicationRecord

    def Adjustment.types()
        return ['Overpayment', 'Underpayment', 'Transfer', 'Actual Income from Amazon', 'Reported Income from Amazon', 'Amazon Fees', 'HMRC Adjustment'] # Add but dont edit!
    end

  # for polymorphism using orders_in and shipments

  def transaction_type()
    return 'ADJUSTMENT'
  end

  def accrual_date()
    return adjustment_date
  end

  def cash_date()
    return adjustment_date
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
      return value
    else
      return 0
    end
  end

  def vat()
    if (vat_value)
      return vat_value
    else
      return 0
    end
  end

  def with_vat()
    return value + vat
  end

  def tax_region()
    if (adjustment_type == 'Amazon Fees')
        return 'EU' # From Belgium in fact
    end
    return 'UK'
  end

  def is_vatable()
    vatable_codes = ['Overpayment', 'Underpayment', 'Reported Income from Amazon', 'Amazon Fees'] 
    return vatable_codes.include?(adjustment_type)
  end

  def currency()
    return "GBP"
  end

end
