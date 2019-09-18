class AddDescFieldToProdCats < ActiveRecord::Migration[5.0]
  def change
    add_column :product_categories, :catalog_description, :string
  end
end
