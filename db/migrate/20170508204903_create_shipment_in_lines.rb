class CreateShipmentInLines < ActiveRecord::Migration[5.0]
  def change
    create_table :shipment_in_lines do |t|
      t.integer :qty
      t.references :shipment_in_in
      t.references :part

      t.timestamps
    end
  end
end
