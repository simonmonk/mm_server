class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.integer :prospect_id
      t.date :reminder_date
      t.integer :user_id

      t.timestamps
    end
  end
end
