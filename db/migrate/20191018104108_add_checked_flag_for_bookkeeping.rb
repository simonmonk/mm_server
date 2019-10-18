class AddCheckedFlagForBookkeeping < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :is_checked, :boolean, default: false
    add_column :adjustments, :is_checked, :boolean, default: false
    add_column :expenses, :is_checked, :boolean, default: false
    add_column :shipments, :is_checked, :boolean, default: false
  end
end
