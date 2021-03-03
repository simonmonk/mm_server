class AddHsiDtoProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :hs_code_id, :integer
  end
end
