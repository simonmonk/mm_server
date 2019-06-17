class ChangeAdjustmentFieldsAgain < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :vat, :decimal, :precision => 10, :scale => 3
  end
end
