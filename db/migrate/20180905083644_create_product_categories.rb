class CreateProductCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.float :priority

      t.timestamps
    end
    add_column :products, :product_category_id, :integer  
  end
end
