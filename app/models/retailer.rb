class Retailer < ApplicationRecord
    has_many :product_retailers
    has_many :shipments
    has_many :products
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
    
end
