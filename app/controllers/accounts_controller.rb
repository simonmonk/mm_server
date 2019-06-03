require 'net/http'
require 'uri'
require 'json'


class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  def cashflow
    render :layout => false
  end

  def vat_report
    render :layout => false
  end

  # API for the node server to call

  def vatObligations # API receiver from the Node app
    # Now merge it into the database
    obs = params['obligations']
    obs.each do | ob |
      period_key = ob['periodKey']
      puts period_key
      existing_return = VatLiability.find_by_period_key(period_key)
      if (existing_return)
        # update existing return
        puts "existing"
        existing_return.update(start_date: ob['start'], end_date: ob['end'], due_date: ob['due'], status: ob['status'], period_key: period_key, received_date: ob['received'])
      else
        # add new return
        puts "new"
        new_return = VatLiability.create(start_date: ob['start'], end_date: ob['end'], due_date: ob['due'], status: ob['status'], period_key: period_key, received_date: ob['received'])
        new_return.save
        puts new_return.to_json
      end
    end

    render :layout => false
  end

  # end of API for the Node server to call

  # UI for VAT
  def vat
  end

  # JSON interface to Vue UI
  #

  # VAT obligations from the database. Put there by the Node server
  def vat_obligations
    render :json => VatLiability.all
  end

  # VAT figures from the database for the date range
  def vat_figures
    from_date = params['from_date']
    to_date = params['to_date']
    render :json => Account.calc_vat_figures(from_date, to_date)
  end

  def vatSummary
    obligation_id = params['obligation_id'].to_i
    ob = VatLiability.find(obligation_id)
    render :json => ob.calc_vat_return()
  end

  # end of JSON interface to Vue UI

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :code, :from, :to, :obligation_id)
    end
end
