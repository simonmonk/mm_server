class CreateRetailers < ActiveRecord::Migration[5.0]
  def change
    create_table :retailers do |t|
      t.string :name
      t.string :contact_name
      t.string :contact_email
      t.text :notes

      t.timestamps
    end
  end
end
