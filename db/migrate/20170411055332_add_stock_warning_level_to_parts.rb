class AddStockWarningLevelToParts < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :stock_warning_level, :integer
  end
end
