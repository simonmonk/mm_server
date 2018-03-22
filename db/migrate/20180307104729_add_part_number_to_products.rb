class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :wholesale_price_usd, :decimal, :precision => 10, :scale => 3
      add_column :products, :retail_price_usd, :decimal, :precision => 10, :scale => 3
      add_column :products, :harmoized_tarrif_number, :string
      add_column :products, :country_of_origin, :string
      add_column :products, :short_description, :text
      add_column :products, :long_description, :text
      add_column :products, :product_photo_uri, :text
  end
end
