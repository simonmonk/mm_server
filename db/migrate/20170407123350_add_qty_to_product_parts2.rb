class AddQtyToProductParts2 < ActiveRecord::Migration[5.0]
  def change
    add_column :product_parts, :qty, :integer
  end
end
