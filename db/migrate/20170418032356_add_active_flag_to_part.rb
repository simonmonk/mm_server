class AddActiveFlagToPart < ActiveRecord::Migration[5.0]
  def change
      add_column :parts, :active, :boolean, :default => true
  end
end
