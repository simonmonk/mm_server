class AdAdjTypeLinkToAdjustment < ActiveRecord::Migration[5.0]
  def change
    add_column :adjustments, :adjustment_type_id, :integer
  end
end
