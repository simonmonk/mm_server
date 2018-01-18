class CreateAssemblies < ActiveRecord::Migration[5.0]
  def change
    create_table :assemblies do |t|
      t.string :name
      t.integer :qty
      t.float :labour

      t.timestamps
    end
  end
end
