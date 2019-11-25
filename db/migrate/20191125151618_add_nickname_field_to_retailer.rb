class AddNicknameFieldToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :nickname, :string
  end
end
