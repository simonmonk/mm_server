class Adjustment < ApplicationRecord

    def Adjustment.types()
        return ['Overpayment', 'Underpayment', 'Transfer', 'Income from Amazon', 'Amazon Fees'] # Add but dont edit!
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
    return value
  end

  def vat()
    return vat_value
  end

  def with_vat()
    return value + vat_value
  end

  def tax_region()
    if (adjustment_type == 'Amazon Fees')
        return 'EU' # From Belgium in fact
    end
    return 'UK'
  end

  def is_vatable()
    return false
  end

  def currency()
    return "GBP"
  end

end
