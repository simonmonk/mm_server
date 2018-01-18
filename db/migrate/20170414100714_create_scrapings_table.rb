class CreateScrapingsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :scrapings_tables do |t|
      t.string :result_type
      t.string :result_value
      t.references :product_retailer, foreign_key: true
      t.timestamps
    end
  end
end
