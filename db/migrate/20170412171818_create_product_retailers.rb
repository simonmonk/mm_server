class CreateProductRetailers < ActiveRecord::Migration[5.0]
  def change
    create_table :product_retailers do |t|
      t.string :url
      t.string :regex
      t.references :product, foreign_key: true
      t.references :retailer, foreign_key: true

      t.timestamps
    end
  end
end
