class AddShippingTypeFieldToRetailerAndShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :shipping_provider_shipping_type, :string
    add_column :retailers, :pref_shipping_provider_shipping_type, :string
  end
end
