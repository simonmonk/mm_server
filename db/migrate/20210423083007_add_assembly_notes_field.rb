class AddAssemblyNotesField < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :notes, :string
  end
end
