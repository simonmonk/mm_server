class AddTrackingInfoToShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :tracking_info, :string
  end
end
