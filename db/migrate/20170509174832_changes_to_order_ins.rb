class ChangesToOrderIns < ActiveRecord::Migration[5.0]
  def change
      add_column :order_ins, :currency, :string
      add_column :order_ins, :exch_rate, :decimal, :precision => 10, :scale => 3
      add_column :order_in_lines, :price, :decimal, :precision => 10, :scale => 3
  end
end
