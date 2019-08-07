class CreateAssemblyCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :assembly_categories do |t|
      t.string :name
      t.integer :priority

      t.timestamps
    end
    AssemblyCategory.create :name => 'Bagged PCBs', :priority => 10
    AssemblyCategory.create :name => 'Component Bags', :priority => 20
    AssemblyCategory.create :name => 'Hardware Bags', :priority => 30
    AssemblyCategory.create :name => 'Other', :priority => 90
    add_column :assemblies, :assembly_category_id, :integer
  end
end
