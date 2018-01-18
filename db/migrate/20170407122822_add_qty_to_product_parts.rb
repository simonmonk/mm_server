class AddQtyToProductParts < ActiveRecord::Migration[5.0]
  def change
    add_column :product_parts, :fieldname, :integer
  end
end
