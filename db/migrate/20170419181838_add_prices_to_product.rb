class AddPricesToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :wholesale_price, :decimal, :precision => 10, :scale => 3
    add_column :products, :retail_price, :decimal, :precision => 10, :scale => 3
    add_column :products, :notes, :text
  end
end
