class CreateCommunications < ActiveRecord::Migration[5.0]
  def change
    create_table :communications do |t|
      t.integer :prospect_id
      t.date :communication_date
      t.integer :user_id
      t.text :notes
      t.string :email_url

      t.timestamps
    end
  end
end
