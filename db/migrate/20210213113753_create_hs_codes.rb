class CreateHsCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :hs_codes do |t|
      t.string :code
      t.string :nickname
      t.string :description
      t.string :url
      t.string :notes

      t.timestamps
    end
  end
end
