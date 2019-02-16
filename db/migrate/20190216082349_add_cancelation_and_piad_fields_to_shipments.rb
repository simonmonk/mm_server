class AddCancelationAndPiadFieldsToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :is_cancelled, :boolean
    add_column :shipments, :total_invoice_collected, :decimal, :precision => 10, :scale => 3
  end
end
