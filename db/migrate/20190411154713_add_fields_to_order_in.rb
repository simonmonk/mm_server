class AddFieldsToOrderIn < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :invoice_exact_amount, :decimal, :precision => 10, :scale => 3
  end
end
