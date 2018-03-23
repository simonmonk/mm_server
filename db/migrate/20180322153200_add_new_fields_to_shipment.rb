class AddNewFieldsToShipment < ActiveRecord::Migration[5.0]
  def change
      add_column :shipments, :date_order_received, :date
      add_column :shipments, :date_dispatched, :date
      add_column :shipments, :date_invoice_sent, :date
      add_column :shipments, :date_payment_reminder, :date
      add_column :shipments, :order_email_link, :string
      add_column :shipments, :po_reference, :string
      add_column :shipments, :invoice_number, :string
      add_column :shipments, :shipping_cost, :decimal, :precision => 10, :scale => 3
      add_column :shipments, :shipping_provider, :string
      add_column :shipments, :shipping_provider_ac_no, :string
      add_column :shipments, :discount, :decimal, :precision => 10, :scale => 3
  end
end
