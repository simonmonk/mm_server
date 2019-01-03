class AddNewDeprecatedProductFlag < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :end_of_line_in_catalog, :boolean
  end
end
