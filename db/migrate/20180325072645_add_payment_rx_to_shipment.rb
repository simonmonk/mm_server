class AddPaymentRxToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :date_payment_received, :date
  end
end
