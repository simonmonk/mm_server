class AddShowForeignSkUflagToSupplier < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :show_foreign_sku, :boolean
  end
end
