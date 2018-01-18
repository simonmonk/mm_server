class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.references :retailer, foreign_key: true
      t.date :dispatched
      t.text :notes

      t.timestamps
    end
  end
end
