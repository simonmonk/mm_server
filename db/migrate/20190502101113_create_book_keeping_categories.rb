class CreateBookKeepingCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :book_keeping_categories do |t|
      t.string :name
      t.string :code
      t.string :description
      t.timestamps
    end
    BookKeepingCategory.create :name => "Materials (Parts)", :code => "PAR", :description => "Materials used for the manufacture of Products"
    BookKeepingCategory.create :name => "Materials (General)", :code => "MAT", :description => "Materials that don't end up in a product"
    BookKeepingCategory.create :name => "Equipment and Furnature", :code => "EQU", :description => "Computers, machines, furniture and other items that depreciate"
    BookKeepingCategory.create :name => "Packaging", :code => "PACK", :description => "Big boxes count, but boxes that are part of a product don't"
    BookKeepingCategory.create :name => "Stationary", :code => "STAT", :description => "Paper, pens etc. but NOT labels used for products"
    BookKeepingCategory.create :name => "Software and IT", :code => "SOFT", :description => "Include web hosting, Domain registrations as well as software licenses"
    BookKeepingCategory.create :name => "Bank Charges", :code => "BANK", :description => "Payments to the bank for the privilege of letting them make money using our money"
    BookKeepingCategory.create :name => "PayPal Fees", :code => "PPFEES", :description => "Because they can!"
    BookKeepingCategory.create :name => "Accountancy", :code => "ACC", :description => "Tax return and payroll services but NOT the PAYE and wages themselves"
    BookKeepingCategory.create :name => "Professional Services", :code => "PS", :description => "Consultancy costs, e.g. Marketing or security advice"
    BookKeepingCategory.create :name => "Shipping", :code => "POST", :description => "DON'T include Post Office"
    BookKeepingCategory.create :name => "Postage", :code => "POST", :description => "Should include All shipping costs BUT Post Office only"
    BookKeepingCategory.create :name => "Insurance", :code => "INS", :description => "Because you never know!"
    BookKeepingCategory.create :name => "Wages & PAYE", :code => "WAG", :description => "Wages, PAYE, Pension payments as well as mileage payments, but NOT payroll admin costs"
    BookKeepingCategory.create :name => "Property Costs", :code => "PROP", :description => "Include rent, property maintenace charges, signage, fire extinguishers etc."
    BookKeepingCategory.create :name => "Subsistance", :code => "SUBS", :description => "Hotel, food etc when travelling for work"
    


  end
end
