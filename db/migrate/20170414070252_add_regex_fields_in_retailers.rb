class AddRegexFieldsInRetailers < ActiveRecord::Migration[5.0]
  def change
      add_column :retailers, :regex_qty, :string
      add_column :retailers, :regex_oos, :string
  end
end
