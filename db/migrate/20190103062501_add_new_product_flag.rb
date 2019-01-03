class AddNewProductFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :new_in_catalog, :boolean
  end
end
