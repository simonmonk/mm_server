class CreateShipmentProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :shipment_products do |t|
      t.references :shipment, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :qty

      t.timestamps
    end
  end
end
