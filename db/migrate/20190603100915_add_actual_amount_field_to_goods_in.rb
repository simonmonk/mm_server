class AddActualAmountFieldToGoodsIn < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :actually_paid_gbp, :decimal, :precision => 10, :scale => 3
  end
end
