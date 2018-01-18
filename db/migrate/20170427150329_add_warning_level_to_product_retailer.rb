class AddWarningLevelToProductRetailer < ActiveRecord::Migration[5.0]
  def change
      add_column :product_retailers, :warn_qty, :integer
  end
end
