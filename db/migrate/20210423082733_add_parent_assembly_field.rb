class AddParentAssemblyField < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :parent_assembly_id, :integer
  end
end
