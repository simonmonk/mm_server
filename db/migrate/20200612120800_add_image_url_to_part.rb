class AddImageUrlToPart < ActiveRecord::Migration[5.0]
  def change
    add_column :parts, :image_url, :string
  end
end
