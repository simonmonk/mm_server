class AddShippingToPart < ActiveRecord::Migration[5.0]
  def change
      add_column :parts, :shipping_cost, :decimal, :precision => 10, :scale => 3
  end
end
