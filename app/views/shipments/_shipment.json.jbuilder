json.extract! shipment, :id, :retailer_id, :dispatched, :notes, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)
