class FixVatableColumnInRetailer < ActiveRecord::Migration[5.0]
  def change
      change_column :retailers, :vatable, :boolean
  end
end
