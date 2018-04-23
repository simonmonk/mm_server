class AddFieldsToOrderIns < ActiveRecord::Migration[5.0]
  def change
      add_column :order_ins, :order_number, :string
      add_column :order_ins, :date_qr_sent, :date
      add_column :order_ins, :date_po_sent, :date
      
  end
end
