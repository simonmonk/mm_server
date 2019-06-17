class ChangeAdjustmentFieldsAgain2 < ActiveRecord::Migration[5.0]
  def change
    rename_column :adjustments, :vat, :vat_value
  end
end
