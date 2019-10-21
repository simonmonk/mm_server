class AddAccountToShipment < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :account_id, :integer, default: 1
  end
end
