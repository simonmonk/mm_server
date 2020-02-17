class AddFlagForIncludingSupplierOnWebsire < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :include_in_website, :boolean, default: true
  end
end
