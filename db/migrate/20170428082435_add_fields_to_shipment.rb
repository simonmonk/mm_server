class AddFieldsToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :stock_subtracted, :boolean
      add_column :shipments, :retailer_shipment_id, :string
  end
end
