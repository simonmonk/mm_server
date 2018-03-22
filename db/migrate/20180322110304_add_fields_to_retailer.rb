class AddFieldsToRetailer < ActiveRecord::Migration[5.0]
  def change
      add_column :retailers, :fao_billing, :string
      add_column :retailers, :billing_ad_line1, :string
      add_column :retailers, :billing_ad_line2, :string
      add_column :retailers, :billing_ad_city, :string
      add_column :retailers, :billing_ad_postal_code, :string
      add_column :retailers, :billing_ad_country, :string
      add_column :retailers, :billing_ad_tel, :string
      add_column :retailers, :fao_delivery, :string
      add_column :retailers, :delivery_ad_line1, :string
      add_column :retailers, :delivery_ad_line2, :string
      add_column :retailers, :delivery_ad_city, :string
      add_column :retailers, :delivery_ad_postal_code, :string
      add_column :retailers, :delivery_ad_country, :string
      add_column :retailers, :delivery_ad_tel, :string
      
      add_column :retailers, :vatable, :booleon
      add_column :retailers, :vat_number, :string
      add_column :retailers, :pref_shipping_provider, :string
      add_column :retailers, :pref_shipping_provider_ac_no, :string
      add_column :retailers, :pref_currency, :string
  end
end
