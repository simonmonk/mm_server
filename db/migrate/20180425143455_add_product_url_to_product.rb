class AddProductUrlToProduct < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :product_url, :string
  end
end
