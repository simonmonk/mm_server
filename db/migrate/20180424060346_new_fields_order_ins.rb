class NewFieldsOrderIns < ActiveRecord::Migration[5.0]
  def change
      add_column :order_ins, :vat_info_collected, :string
      add_column :order_ins, :quotation_received, :date
  end
end
