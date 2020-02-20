class AddCarouselImageAndOtherFieldsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :carousel_0, :string
    add_column :products, :carousel_1, :string
    add_column :products, :carousel_2, :string
    add_column :products, :carousel_3, :string
    add_column :products, :carousel_4, :string

    add_column :products, :tutorial_url, :string
    add_column :products, :datasheet_url, :string
    add_column :products, :video_url_0, :string
  end
end
