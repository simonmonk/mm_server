class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_time
      t.string :transaction_type
      t.text :description

      t.timestamps
    end
  end
end
