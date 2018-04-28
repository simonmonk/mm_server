class AddBarcodeToProduct < ActiveRecord::Migration[5.0]
  def change
      add_attachment :products, :barcode
      add_column :products, :barcode_value, :string
  end
end
