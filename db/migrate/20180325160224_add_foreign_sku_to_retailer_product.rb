class AddForeignSkuToRetailerProduct < ActiveRecord::Migration[5.0]
  def change
      add_column :product_retailers, :sku, :string
  end
end
