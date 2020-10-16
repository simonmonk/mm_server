class AddCompatabilityFieldToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :compatability_image, :string
  end
end
