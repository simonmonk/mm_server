class AddDefaultProductCategories < ActiveRecord::Migration[5.0]
  def change
      ProductCategory.create :name => 'BBC micro:bit', :priority => 10
      ProductCategory.create :name => 'Raspberry Pi', :priority => 20
      ProductCategory.create :name => 'General Electronics', :priority => 30
  end
end
