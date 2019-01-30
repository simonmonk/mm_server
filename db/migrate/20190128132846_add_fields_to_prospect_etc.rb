class AddFieldsToProspectEtc < ActiveRecord::Migration[5.0]
  def change
    add_column :prospects, :website, :string
    add_column :prospects, :quality, :integer
    add_column :prospects, :retailer, :integer
    
    add_column :communications, :incoming, :boolean
  end
end
