class ModifyOrderInLineOrderCode < ActiveRecord::Migration[5.0]
  def change
    add_column :order_in_lines, :order_code, :string
  end
end
