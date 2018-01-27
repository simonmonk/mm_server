class AddCategoryToPart < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :category_id, :integer
  end
end
