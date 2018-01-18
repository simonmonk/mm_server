class AddShippingCostToRoderIns < ActiveRecord::Migration[5.0]
  def change
      add_column :order_ins, :shipping, :decimal, :precision => 10, :scale => 3
  end
end
