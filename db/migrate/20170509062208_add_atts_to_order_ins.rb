class AddAttsToOrderIns < ActiveRecord::Migration[5.0]
  def change
      add_column :order_ins, :placed_date, :date
      add_column :order_ins, :supplier_id, :integer
      add_column :order_ins, :notes, :text
  end
end
