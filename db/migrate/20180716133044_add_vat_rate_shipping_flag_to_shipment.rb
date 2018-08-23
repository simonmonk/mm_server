class AddVatRateShippingFlagToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :apply_vat_to_shipping, :boolean
  end
end
