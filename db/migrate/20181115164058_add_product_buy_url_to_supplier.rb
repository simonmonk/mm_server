class AddProductBuyUrlToSupplier < ActiveRecord::Migration[5.0]
  def change
    add_column :suppliers, :product_url_base, :string
  end
end
