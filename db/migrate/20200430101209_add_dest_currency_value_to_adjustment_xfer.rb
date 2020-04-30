class AddDestCurrencyValueToAdjustmentXfer < ActiveRecord::Migration[5.0]
  def change
    remove_column :adjustments, :exch_rate
    add_column :adjustments, :destination_currency_value, :decimal, :precision => 10, :scale => 3
  end
end
