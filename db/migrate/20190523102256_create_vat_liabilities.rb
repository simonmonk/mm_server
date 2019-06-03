class CreateVatLiabilities < ActiveRecord::Migration[5.0]
  def change
    create_table :vat_liabilities do |t|
      t.date :start_date
      t.date :end_date
      t.date :due_date
      t.string :status
      t.string :period_key
      t.date :received_date

      t.timestamps
    end
  end
end
