class AddRegexFieldsInSuppliers < ActiveRecord::Migration[5.0]
  def change
      add_column :suppliers, :regex_qty, :string
      add_column :suppliers, :regex_oos, :string
      remove_column :product_retailers, :regex
  end
end
