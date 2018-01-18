class ChangeKeysOnProductRetailerSales < ActiveRecord::Migration[5.0]
  def change
    create_table :sales do |t|
      t.integer :week
      t.integer :count
      t.decimal :value, :precision => 10, :scale => 3
      t.references :product
      t.references :retailer

      t.timestamps
    end
    drop_table :product_retailer_sales
    drop_table :scrapings_tables
    drop_table :scrapings
  end
end
