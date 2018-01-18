class CreatePartSuppliers < ActiveRecord::Migration[5.0]
  def change
    create_table :part_suppliers do |t|
      t.string :url
      t.decimal :price, precision: 10, scale: 2
      t.references :part, foreign_key: true
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
