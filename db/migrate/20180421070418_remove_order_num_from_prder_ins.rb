class RemoveOrderNumFromPrderIns < ActiveRecord::Migration[5.0]
  def change
      remove_column :order_ins, :order_number
  end
end
