class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    Account.create :name => "Current", :code => "CUR"
    Account.create :name => "Credit Card", :code => "CC"
    Account.create :name => "PayPal", :code => "PPL"
    Account.create :name => "World First", :code => "WF"
  end
end
