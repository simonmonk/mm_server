class AddSubRetailerToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :original_retailer_id, :integer
  end
end
