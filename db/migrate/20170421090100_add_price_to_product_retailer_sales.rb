class AddPriceToProductRetailerSales < ActiveRecord::Migration[5.0]
  def change
    add_column :product_retailer_sales, :value, :decimal, :precision => 10, :scale => 3
  end
end
