class PartAssemPartProdPartsQtyToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :product_parts, :qty, :float
    change_column :assembly_parts, :qty, :float
  end
end
