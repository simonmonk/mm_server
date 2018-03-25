class AddStateToRetailerAddreses < ActiveRecord::Migration[5.0]
  def change
      add_column :retailers, :billing_ad_state, :string
      add_column :retailers, :delivery_ad_state, :string
  end
end
