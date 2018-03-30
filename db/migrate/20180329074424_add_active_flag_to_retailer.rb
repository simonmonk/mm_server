class AddActiveFlagToRetailer < ActiveRecord::Migration[5.0]
  def change
      add_column :retailers, :active, :booleon
  end
end
