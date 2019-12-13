class AddCreditDaysFieldToShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :credit_days, :integer, default: false
  end
end
