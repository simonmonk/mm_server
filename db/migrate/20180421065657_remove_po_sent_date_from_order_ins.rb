class RemovePoSentDateFromOrderIns < ActiveRecord::Migration[5.0]
  def change
      remove_column :order_ins, :date_po_sent
  end
end
