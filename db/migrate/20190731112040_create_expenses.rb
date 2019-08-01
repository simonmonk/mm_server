class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.date :incurred_date
      t.date :reimbursed_date
      t.integer :user_id
      t.integer :account_id
      t.string :supplier
      t.string :description
      t.float :without_vat
      t.float :vat
      t.float :with_vat
      t.boolean :is_mileage
      t.integer :miles
      t.float :mileage_rate

      t.timestamps
    end
  end
end
