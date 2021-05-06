class AddManuTimeToAssAndProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :build_time_mins, :float
    add_column :products, :build_time_mins, :float
  end
end
