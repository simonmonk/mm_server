class CreateProductRetailerSales < ActiveRecord::Migration[5.0]
  def change
    create_table :product_retailer_sales do |t|
      t.integer :week
      t.integer :count
      t.references :product_retailer

      t.timestamps
    end
  end
end
