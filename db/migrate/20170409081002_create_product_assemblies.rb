class CreateProductAssemblies < ActiveRecord::Migration[5.0]
  def change
    create_table :product_assemblies do |t|
      t.integer :qty
      t.belongs_to :product, foreign_key: true
      t.belongs_to :assembly, foreign_key: true

      t.timestamps
    end
  end
end
