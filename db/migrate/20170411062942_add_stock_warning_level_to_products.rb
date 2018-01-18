class AddStockWarningLevelToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :stock_warning_level, :integer
  end
end
