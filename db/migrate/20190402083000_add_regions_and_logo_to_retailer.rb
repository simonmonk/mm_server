class AddRegionsAndLogoToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :logo_url, :string
    add_column :retailers, :logo_buy_url, :string
    add_column :retailers, :region_id, :integer
  end
end
