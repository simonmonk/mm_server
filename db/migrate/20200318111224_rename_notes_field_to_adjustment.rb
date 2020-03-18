class RenameNotesFieldToAdjustment < ActiveRecord::Migration[5.0]
  def change
    rename_column :adjustments, :notes, :adj_notes
  end
end
