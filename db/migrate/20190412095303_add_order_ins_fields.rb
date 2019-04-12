class AddOrderInsFields < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :invoice_vat_ammout, :decimal, :precision => 10, :scale => 3
    add_column :order_ins, :invoice_goods_ammout, :decimal, :precision => 10, :scale => 3
    rename_column :order_ins, :invoice_exact_amount, :invoice_total_ammount 
  end
end
