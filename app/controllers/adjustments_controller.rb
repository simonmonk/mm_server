class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /adjustments
  # GET /adjustments.json
  def index
    @adjustments = Adjustment.all.order(:adjustment_date)
  end

  # GET /adjustments/1
  # GET /adjustments/1.json
  def show
  end

  # GET /adjustments/new
  def new
    @adjustment = Adjustment.new
  end

  # GET /adjustments/1/edit
  def edit
  end

  # POST /adjustments
  # POST /adjustments.json
  def create
    @adjustment = Adjustment.new(adjustment_params)

    respond_to do |format|
      if @adjustment.save
        @adjustments = Adjustment.all
        format.html { render :index}
        format.json { render :json => @adjustment }
      else
        format.html { render :new }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  def amazon_countries
    render :json => Adjustment.amazon_countries
  end

  def amazon_months
    render :json => Adjustment.amazon_months
  end

  def generate_amazon_adjustments
    result = ''
    date = Date.parse(params['amazon_month']).end_of_month()
    income = params['amazon_income'].to_f
    expense = params['amazon_expenses'].to_f
    country = params['amazon_country']
    msg_expenses = params['amazon_adj_msg_expenses']
    msg_income = params['amazon_adj_msg_income']

    desc = date.to_s + ' ' + country

    if (Adjustment.find_by(description: desc))
      result += "There are all ready adjustment(s) for this month and country: \n" + desc + '. To replace them, delete them manually and do this again.'
    else
      result += generate_amazon_income_adjustment(date, income, country, desc, msg_income)
      result += generate_amazon_expense_adjustment(date, expense, country, desc, msg_expenses)
    end
    render :json => result.to_json
  end


  def generate_amazon_income_adjustment(date, income, country, desc, notes)
    # notes should include the gross amount used in the calcs for value and vat
    adj_type = AdjustmentType.for_code('AMAZON_REPORTED')
    vat_value = 0
    val = income
    if (country == 'UK')
      vat_value = (income / 6).round(2)
      val = (income - (income / 6)).round(2)
    elsif (country == 'USA')
      #acc = Account.for_code('WF').id 
    else
      # by default europe for Amazon
      vat_value = (income / 6).round(2)
      val = (income - (income / 6)).round(2)
    end
    amazon_income_adjustment = Adjustment.new(
      adjustment_date: date, 
      value: val, 
      vat_value: vat_value,
      tax_region: Adjustment.region_for_country(country), # ['UK', 'EU', 'Rest of the World']
      adjustment_type_id: adj_type.id,
      description: desc, # don'r mess with format of this, its used as a key ro check adjusment not already created
      from_account_id: Account.for_code('AM').id,
      to_account_id: nil, 
      adj_notes: notes
      )
    if (amazon_income_adjustment.save)
      return 'Created adjustment ' + adj_type.name + ' ' + desc + "\n"
    else
      return 'Could not create adjustment' + adj_type.name + ' ' + desc + "\n"
    end
  end


  def generate_amazon_expense_adjustment(date, expense, country, desc, notes)
    adj_type = AdjustmentType.for_code('AMAZON_FEES')
    tax_region = 'Rest of the World'
    vat_value = (expense / 5).round(2)
    if (country == 'UK')
      tax_region = 'UK'
    elsif (Adjustment.amazon_eu_countries.include?(country))
      tax_region = 'EU'
    end
    amazon_income_adjustment = Adjustment.new(
      adjustment_date: date, 
      value: expense, 
      vat_value: vat_value,
      tax_region: tax_region, # ['UK', 'EU', 'Rest of the World']
      adjustment_type_id: adj_type.id,
      description: desc, # don'r mess with format of this, its used as a key ro check adjusment not already created
      to_account_id: Account.for_code('AM').id,
      from_account_id: Account.for_code('AM').id, # fees never actuall payed, they just get deducted from Amazon balance
      adj_notes: notes
      )
    if (amazon_income_adjustment.save)
      return 'Created adjustment ' + adj_type.name + ' ' + desc + "\n"
    else
      return 'Could not create adjustment' + adj_type.name + ' ' + desc + "\n"
    end
  end



  # PATCH/PUT /adjustments/1
  # PATCH/PUT /adjustments/1.json
  def update
    respond_to do |format|
      if @adjustment.update(adjustment_params)
        @adjustments = Adjustment.all
        format.html { render :index}
        format.json { render :json => @adjustment}
      else
        format.html { render :edit }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.json
  def destroy
    @adjustment.destroy
    respond_to do |format|
      format.html { redirect_to adjustments_url, notice: 'Adjustment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adjustment
      @adjustment = Adjustment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adjustment_params
      params.require(:adjustment).permit(:adjustment_date, :value, :adjustment_type, :description, :organisation, :vat_value, :tax_region,
            :from_account_id, :to_account_id, :adjustment_type_id, :destination_currency_value)
    end
end
