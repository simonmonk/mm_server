class AddProductFieldForHrImages < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :high_res_image_share, :string
  end
end
