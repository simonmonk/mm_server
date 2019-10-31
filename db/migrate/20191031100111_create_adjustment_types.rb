class CreateAdjustmentTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :adjustment_types do |t|
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end
    AdjustmentType.create :code => 'OVER_PAYMENT', :name => 'Overpayment', :description => 'Overpayment by a customer'
    AdjustmentType.create :code => 'UNDER_PAYMENT', :name => 'Underpayment', :description => 'Underpayment by a customer'
    AdjustmentType.create :code => 'TRANSFER', :name => 'Transfer', :description => 'Transfer from one account to another'
    AdjustmentType.create :code => 'AMAZON_ACTUAL', :name => 'Actual Income from Amazon', :description => 'From Amazon Statement'
    AdjustmentType.create :code => 'AMAZON_REPORTED', :name => 'Reported Income from Amazon', :description => 'From Amazon Statement'
    AdjustmentType.create :code => 'AMAZON_FEES', :name => 'Amazon Fees', :description => 'From Amazon Statement'
    AdjustmentType.create :code => 'HMRC', :name => 'HMRC Adjustment', :description => 'Correction from HMRC'
    AdjustmentType.create :code => 'EBAY', :name => 'Ebay Sale', :description => 'Disposal of unwanted stock through eBay'
    AdjustmentType.create :code => 'REIMBURSEMENT', :name => 'Reimbursement', :description => 'Reimbursement (E.g personal CC used accidentally for MM purchase)'   
  end
end
