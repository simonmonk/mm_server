class AddProductPriceToShipmentProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :shipment_products, :price, :decimal, :precision => 10, :scale => 3
  end
end
