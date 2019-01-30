class AddMoreFieldsToProspectEtc < ActiveRecord::Migration[5.0]
  def change
    add_column :prospects, :lead_source, :string
  end
end
