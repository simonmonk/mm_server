class AddVatActionToExpense < ActiveRecord::Migration[5.0]
  def change
    add_column :expenses, :vat_action, :string
  end
end
