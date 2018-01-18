class AddNotesToPart < ActiveRecord::Migration[5.0]
  def change
      add_column :parts, :notes, :text
  end
end
