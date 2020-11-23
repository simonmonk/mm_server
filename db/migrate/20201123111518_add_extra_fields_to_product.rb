class AddExtraFieldsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :wholesale_price_catalog, :decimal, :precision => 10, :scale => 3
    add_column :products, :retail_price_catalog, :decimal, :precision => 10, :scale => 3
    add_column :products, :lessons_url, :string
  end
end
