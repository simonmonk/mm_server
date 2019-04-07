class Retailer < ApplicationRecord
    has_many :product_retailers
    has_many :shipments
    has_many :products
    belongs_to :region
    validates :name, presence: true
    
    
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

    def as_json(options={})
        super(:methods => [:owes_money])
    end

    def num_orders()
        return shipments.length
    end
    
end
