class AddCurrencyTableWithRows < ActiveRecord::Migration[5.0]
  def change
      create_table :currencies do |t|
        t.string :name
        t.string :symbol
        t.decimal :per_pound, precision: 10, scale: 2
        t.timestamps
      end
  end

end
