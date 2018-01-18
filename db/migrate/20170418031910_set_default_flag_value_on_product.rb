class SetDefaultFlagValueOnProduct < ActiveRecord::Migration[5.0]
  def change
      change_column :products, :active, :boolean, :default => true
  end
end
