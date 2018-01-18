class CreateShipmentIns < ActiveRecord::Migration[5.0]
  def change
    create_table :shipment_ins do |t|
      t.references :order_in

      t.timestamps
    end
  end
end
