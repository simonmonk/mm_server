class AddInstructionsUrlFieldToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :instructions_url, :string
  end
end
