class TidyOrderInStuff < ActiveRecord::Migration[5.0]
  def change
      drop_table :shipment_ins
      drop_table :shipment_in_lines
      add_column :order_in_lines, :qty_in, :integer
  end
end
