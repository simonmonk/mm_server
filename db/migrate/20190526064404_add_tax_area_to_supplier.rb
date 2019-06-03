class AddTaxAreaToSupplier < ActiveRecord::Migration[5.0]
  def change
    add_column :suppliers, :tax_region, :string
  end
end
