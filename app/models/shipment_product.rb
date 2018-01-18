class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product
end
