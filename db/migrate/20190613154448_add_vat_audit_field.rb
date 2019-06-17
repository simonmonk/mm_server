class AddVatAuditField < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :vat_action, :string
    add_column :shipments, :vat_action, :string
    add_column :adjustments, :vat_action, :string
  end
end
