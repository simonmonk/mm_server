class AddForeignKeysToOrderInLines < ActiveRecord::Migration[5.0]
  def change
    add_column :order_in_lines, :cost_centre_id, :integer
    add_column :order_in_lines, :book_keeping_category_id, :integer
    add_column :order_ins, :account_id, :integer
  end
end
