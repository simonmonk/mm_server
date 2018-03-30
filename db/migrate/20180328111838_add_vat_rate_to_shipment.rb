class AddVatRateToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :vat_rate, :decimal, :precision => 10, :scale => 3
  end
end
