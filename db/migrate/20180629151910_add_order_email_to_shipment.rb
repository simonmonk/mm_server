class AddOrderEmailToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :order_email, :string
  end
end
