class CreateProductParts < ActiveRecord::Migration[5.0]
  def change
    create_table :product_parts do |t|
      t.belongs_to :part, foreign_key: true
      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
