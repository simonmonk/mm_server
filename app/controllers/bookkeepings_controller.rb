class BookkeepingsController < ApplicationController
  skip_before_filter :verify_authenticity_token 


  # Return json for all the transactions between a certain period
  # where a transaction is a Shipment, OrderIn, Adjustment or Expense
  def transactions
    from_date = Date.parse(params['from_date'])
    to_date = Date.parse(params['to_date'])
    data_summary = Account.generateVATReportData(from_date, to_date)
    data = data_summary[0]
    summary = data_summary[1]
    render :json => data
  end

  # Generate a spreadsheet for the date range
  def create_spreadsheet
    # from_date = Date.parse(params['from_date'])
    # to_date = Date.parse(params['to_date'])
    render xlsx: "spreadsheet", template: "bookkeepings/spreadsheet.xlsx.axlsx" #, from_date: from_date, to_date: to_date
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bookkeeping_params
    params.require(:bookkeeping).permit(:from_date, :to_date)
  end

end
