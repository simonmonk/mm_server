class AddTaxRegionToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :tax_region, :string
  end
end
