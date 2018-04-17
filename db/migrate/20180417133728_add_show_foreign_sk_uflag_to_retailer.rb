class AddShowForeignSkUflagToRetailer < ActiveRecord::Migration[5.0]
  def change
      add_column :retailers, :show_foreign_sku, :boolean
      remove_column :shipments, :show_foreign_sku
      remove_column :suppliers, :show_foreign_sku
  end
end
