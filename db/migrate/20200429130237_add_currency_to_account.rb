class AddCurrencyToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :currency_id, :integer, default: 1
  end
end
