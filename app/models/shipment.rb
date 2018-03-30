class Shipment < ApplicationRecord
  belongs_to :retailer
  has_many :shipment_products
    
  validates_uniqueness_of :invoice_number
    
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

  def priority()
    if (date_payment_received and date_payment_received <= Date.current)
        return 3
    else
        if (date_payment_reminder and Date.current < date_payment_reminder)
            return 2
        else
            return 1
        end
    end
  end
    
end
