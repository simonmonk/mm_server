class AddRegions < ActiveRecord::Migration[5.0]
  def change
    add_column :regions, :code, :string
    Region.create :name => "UK", :code => "UK"
    Region.create :name => "USA and Canada", :code => "NA"
    Region.create :name => "Latin America", :code => "LA"
    Region.create :name => "Europe", :code => "EU"
    Region.create :name => "Australasia", :code => "AUS"
    Region.create :name => "Asia", :code => "ASIA"
    Region.create :name => "Africa and Middle East", :code => "AF"
  end
end
