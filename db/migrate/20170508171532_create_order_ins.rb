class CreateOrderIns < ActiveRecord::Migration[5.0]
  def change
    create_table :order_ins do |t|
      t.boolean :open

      t.timestamps
    end
  end
end
