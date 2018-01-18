class CreateAssemblyParts < ActiveRecord::Migration[5.0]
  def change
    create_table :assembly_parts do |t|
      t.integer :qty
      t.belongs_to :part, foreign_key: true
      t.belongs_to :assembly, foreign_key: true

      t.timestamps
    end
  end
end
