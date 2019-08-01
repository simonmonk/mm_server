class AddServiceFlagToOrderIn < ActiveRecord::Migration[5.0]
  def change
    add_column :order_ins, :is_service, :boolean
  end
end
