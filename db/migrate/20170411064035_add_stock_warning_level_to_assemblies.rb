class AddStockWarningLevelToAssemblies < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :stock_warning_level, :integer
  end
end
