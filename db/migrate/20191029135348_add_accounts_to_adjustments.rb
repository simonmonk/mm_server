class AddAccountsToAdjustments < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :from_account_id, :integer
    add_column :adjustments, :to_account_id, :integer
  end
end

