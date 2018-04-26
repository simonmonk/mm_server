class AddCurrencyRows < ActiveRecord::Migration[5.0]
  def change
    Currency.create :name => 'GBP', :symbol => '£', :per_pound => 1.0
    Currency.create :name => 'USD', :symbol => '$', :per_pound => 1.4
  end
end
