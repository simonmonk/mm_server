class AddCatalogFieldToProduct < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :include_in_catalog, :boolean
  end
end
