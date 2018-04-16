class AddReceivedDateToOrderInLine < ActiveRecord::Migration[5.0]
  def change
      add_column :order_in_lines, :date_line_received, :date
  end
end
