class RemoveUnusedAtts < ActiveRecord::Migration[5.0]
  def change
    remove_column :products, :product_part_id
    remove_column :parts, :product_part_id
    remove_column :product_parts, :field_name
  end
end
