class Retailer < ApplicationRecord
    has_many :product_retailers
    has_many :shipments
    has_many :products
    belongs_to :region
    validates :name, presence: true
    
    def is_sample()
        return (name == 'Sending Samples')
    end
    
    def Retailer.with_domain(retailer_domain)
       Retailer.all.each do | retailer |
           if retailer.contact_email and retailer.contact_email.length > 0
              domain = retailer.contact_email.match(/@(\S*)/)[1]
              if (domain == retailer_domain)
                  return retailer
              end
           end
       end
       return nil 
    end


    def owes_money()
        shipments.each do | shipment |
            if (shipment.is_overdue)
                return true
            end
        end
        return false
    end

    def units_and_value_shipped(start_date, end_date)
        #shipments = Shipment.where("date_order_received >= :start_date AND date_order_received < :end_date", {start_date: start_date, end_date: end_date})
        value_sold = 0
        self.shipments.each do | shipment |
            ship_date = shipment.date_order_received
            if (ship_date and ship_date >= start_date and ship_date <= end_date)
                value_sold += shipment.without_vat
            end
        end
        return value_sold
    end



    def as_json(options={})
        super(:methods => [:owes_money, :is_sample])
    end
    
end
