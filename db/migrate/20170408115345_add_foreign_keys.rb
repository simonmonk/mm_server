class AddForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :product_part_id, :integer
    add_column :parts, :product_part_id, :integer
  end
end
