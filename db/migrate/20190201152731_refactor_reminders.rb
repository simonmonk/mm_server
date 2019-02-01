class RefactorReminders < ActiveRecord::Migration[5.0]
  def change
    add_column :prospects, :reminder_date, :date
    drop_table :reminders
  end
end
