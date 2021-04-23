class AddIsPanelAssemblyCatField < ActiveRecord::Migration[5.0]
  def change
    add_column :assembly_categories, :is_panel, :string
  end
end
