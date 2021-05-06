class ChangeAssemblyQtyToBeFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :assemblies, :qty, :float
  end
end
