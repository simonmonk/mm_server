class AddCreditDaysFieldToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :credit_days, :integer, default: 7
    remove_column :shipments, :credit_days
  end
end
