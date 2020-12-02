class AddInvoiceEmailFieldToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :billing_ad_email, :string
  end
end
