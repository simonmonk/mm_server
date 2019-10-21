class BookkeepingsController < ApplicationController
  skip_before_filter :verify_authenticity_token 


  # Return json for all the transactions between a certain period
  # where a transaction is a Shipment, OrderIn, Adjustment or Expense
  def transactions
    from_date = params('from_date')
    to_date = params('to_date')
    data_summary = Account.generateVATReportData(from_date, to_date)
    data = data_summary[0]
    summary = data_summary[1]
    render :json => data
  end

end
