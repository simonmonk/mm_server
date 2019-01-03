class AddNewProductPriceFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :new_price_in_catalog, :boolean
  end
end
