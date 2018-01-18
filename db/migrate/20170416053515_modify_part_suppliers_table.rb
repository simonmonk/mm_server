class ModifyPartSuppliersTable < ActiveRecord::Migration[5.0]
  def change
      add_column :part_suppliers, :code, :string
  end
end
