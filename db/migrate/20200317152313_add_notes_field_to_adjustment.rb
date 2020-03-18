class AddNotesFieldToAdjustment < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :notes, :string
  end
end
