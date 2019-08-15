class AddRohsFlagToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :rohs_compliant, :boolean
  end
end
