class RemovePriceFieldFromPartsSupplier < ActiveRecord::Migration[5.0]
  def change
      remove_column :part_suppliers, :price
  end
end
