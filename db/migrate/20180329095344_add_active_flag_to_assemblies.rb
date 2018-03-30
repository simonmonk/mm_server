class AddActiveFlagToAssemblies < ActiveRecord::Migration[5.0]
  def change
      add_column :assemblies, :active, :boolean
      change_column :retailers, :active, :boolean
  end
end
