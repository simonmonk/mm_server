class CreateParts < ActiveRecord::Migration[5.0]
  def change
    create_table :parts do |t|
      t.string :name
      t.integer :qty
      t.float :cost
      t.string :currency
      t.float :exch_rate

      t.timestamps
    end
  end
end
