class CreateNotificationsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.boolean :dismissed
      t.text :message

      t.timestamps
    end
  end
end
