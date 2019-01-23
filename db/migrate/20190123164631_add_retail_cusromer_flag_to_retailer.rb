class AddRetailCusromerFlagToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :is_retail, :boolean
  end
end
