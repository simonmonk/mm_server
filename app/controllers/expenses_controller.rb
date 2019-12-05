class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      puts "********* creating an expense"
      if @expense.save
        puts "** expense saved"
        puts @expense.id.to_s
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        puts "** expense not saved"
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def import_receipt 
    expense_number = params['expense_number']
    # go and check INVOICES share iff there's a file there move and rename it into /public/expense_receipts
    share = Setting.get_setting('INVOICE_SHARE')
    root_dir = Setting.get_setting('ROOT_DIR')
    files = Dir.glob(share + "/*.pdf")
    if (files.length == 0)
      render :json => 'no file to import'
    elsif (files.length == 1)
      file = files[0]
      dest_file_name = expense_number.to_s + '.pdf'
      dest = root_dir + '/public/expense_receipts/' + dest_file_name
      begin
        FileUtils.mv(file, dest)
      rescue Exception => boom
        return render :json => 'couldnt move file' + boom.to_s
      end
      # also send files to googledrive using gdrive
      puts "********** HERE"
      guid = Rails.application.secrets.EXPENSE_RECEIPTS_SHARE_GUID
      begin
        command = '/home/si/gdrive upload --parent ' + guid + ' ' + dest
        puts "******* command=" + command
        puts system(command)
      rescue Exception => boom
        return render :json => 'couldnt upload to Google Drive: ' + boom.to_s
      end
      render :json => 'ok'
    else
      render :json => 'no file or multiple files'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:incurred_date, :reimbursed_date, 
          :user_id, :account_id, :supplier, :description, :without_vat, 
          :vat, :with_vat, :is_mileage, :miles, :mileage_rate, :expense,
          :cost_centre_id, :is_checked)
    end
end
