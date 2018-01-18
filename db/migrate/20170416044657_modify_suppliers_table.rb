class ModifySuppliersTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :suppliers, :string
    change_table :suppliers do |t|
        t.change :notes, :text
    end
  end
end
