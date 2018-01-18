class AddWeeklySalesToProductRetailer < ActiveRecord::Migration[5.0]
  def change
      add_column :product_retailers, :weekly_sales_avg, :float
  end
end
