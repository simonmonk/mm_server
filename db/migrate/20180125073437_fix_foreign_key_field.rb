class FixForeignKeyField < ActiveRecord::Migration[5.0]
  def change
    remove_column :parts, :category_id
    add_column :parts, :part_category_id, :integer
  end
end
