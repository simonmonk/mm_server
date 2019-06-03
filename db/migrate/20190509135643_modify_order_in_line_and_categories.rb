class ModifyOrderInLineAndCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :order_in_lines, :description, :string
    BookKeepingCategory.create :name => "Directors Salary", :code => "DIR", :description => "Directors pay"
    BookKeepingCategory.create :name => "HMRC", :code => "HMRC", :description => "HMRC payments"
  end
end
