class AddPanelQtyAssemblyField < ActiveRecord::Migration[5.0]
  def change
    add_column :assemblies, :panel_num_boards, :integer
  end
end
