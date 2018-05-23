class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product
    
    
  def wholesale_in_currency()
     if (shipment.retailer.name == 'amazon.com')
         if (product.retail_price_usd)
             return product.retail_price_usd
         else
             return 0
         end
     end
     if (shipment.retailer.pref_currency == 'USD')
         if (product.wholesale_price_usd)
             return product.wholesale_price_usd
         else
             return 0
         end
     end
     return product.wholesale_price
  end
    
end
