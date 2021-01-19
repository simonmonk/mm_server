class AddVideoFieldsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :video_url_1, :string
    add_column :products, :video_url_2, :string
  end
end
