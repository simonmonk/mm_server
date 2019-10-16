class AddWeightToPart < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :weight_g, :float
  end
end
