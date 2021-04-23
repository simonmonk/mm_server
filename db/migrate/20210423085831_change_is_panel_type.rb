class ChangeIsPanelType < ActiveRecord::Migration[5.0]
  def change
    change_column :assembly_categories, :is_panel, :boolean
  end
end
