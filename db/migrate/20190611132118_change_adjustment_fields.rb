class ChangeAdjustmentFields < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :organisation, :string
    add_column :adjustments, :description, :string
    remove_column :adjustments, :notes
  end
end
