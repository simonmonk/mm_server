class CreateOrderInLines < ActiveRecord::Migration[5.0]
  def change
    create_table :order_in_lines do |t|
      t.integer :qty
      t.references :order_in
      t.references :part

      t.timestamps
    end
  end
end
