class AddUrLsToRetailer < ActiveRecord::Migration[5.0]
  def change
    add_column :retailers, :mm_products_url, :string
    add_column :retailers, :base_url, :string
  end
end
