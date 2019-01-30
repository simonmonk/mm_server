class CreateProspects < ActiveRecord::Migration[5.0]
  def change
    create_table :prospects do |t|
      t.string :organisation_name
      t.string :contact_name
      t.string :contact_email
      t.string :country
      t.string :notes
      t.integer :account_manager_user_id

      t.timestamps
    end
  end
end
