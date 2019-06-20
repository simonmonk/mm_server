class AddTaxRegionToAdjustment < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :tax_region, :string
  end
end
