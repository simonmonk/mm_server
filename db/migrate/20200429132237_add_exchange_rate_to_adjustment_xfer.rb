class AddExchangeRateToAdjustmentXfer < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :exch_rate, :decimal, :precision => 10, :scale => 3
  end
end
