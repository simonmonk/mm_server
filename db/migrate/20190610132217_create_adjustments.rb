class CreateAdjustments < ActiveRecord::Migration[5.0]
  def change
    create_table :adjustments do |t|
      t.date :adjustment_date
      t.decimal :value
      t.string :adjustment_type
      t.string :notes

      t.timestamps
    end
  end
end
