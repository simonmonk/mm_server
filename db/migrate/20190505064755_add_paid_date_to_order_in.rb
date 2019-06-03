class AddPaidDateToOrderIn < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :date_payment_made, :date
  end
end
