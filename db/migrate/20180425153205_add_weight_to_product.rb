class AddWeightToProduct < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :weight_g, :decimal, :precision => 10, :scale => 3
  end
end
