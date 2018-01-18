class AddLabourToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :labour, :float
  end
end
