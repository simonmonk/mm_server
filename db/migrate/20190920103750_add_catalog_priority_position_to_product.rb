class AddCatalogPriorityPositionToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :catalog_priority, :float
  end
end
