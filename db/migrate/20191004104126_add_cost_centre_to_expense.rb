class AddCostCentreToExpense < ActiveRecord::Migration[5.0]
  def change
    add_column :expenses, :cost_centre_id, :integer
  end
end
