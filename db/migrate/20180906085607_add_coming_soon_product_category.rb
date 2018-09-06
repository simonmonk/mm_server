class AddComingSoonProductCategory < ActiveRecord::Migration[5.0]
  def change
      ProductCategory.create :name => 'Coming Soon', :priority => 1000
      add_column :products, :release_date, :date
  end
end
