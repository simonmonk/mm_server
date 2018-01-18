class Shipment < ApplicationRecord
  belongs_to :retailer
  has_many :shipment_products
end
