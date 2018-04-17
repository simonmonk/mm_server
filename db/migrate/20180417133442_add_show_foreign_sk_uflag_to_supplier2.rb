class AddShowForeignSkUflagToSupplier2 < ActiveRecord::Migration[5.0]
  def change
      add_column :suppliers, :show_foreign_sku, :boolean
  end
end
