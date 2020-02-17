class RetailersController < ApplicationController
  before_action :set_retailer, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /retailers
  # GET /retailers.json
  def index
    @retailers = Retailer.all.order(:name)
    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @retailers}
  end
  end

  # GET /retailers/1
  # GET /retailers/1.json
  def show
  end

  # GET /retailers/new
  def new
    @retailer = Retailer.new
    @retailer.active = true
  end

  # GET /retailers/1/edit
  def edit
  end

def retailer_list_website
  render :layout => false
end  

def export_csv
  render :layout => false
end
    
def add_product
    product_id = params[:product_id]
    retailer_id = params[:retailer_id]
    results = ProductRetailer.where(product_id: product_id, retailer_id: retailer_id)
    if (results.length == 0)
        pp = ProductRetailer.new(:product_id => product_id, :retailer_id => retailer_id)
        pp.save
    end
    redirect_to :action => "edit", :id => retailer_id
end

  # POST /retailers
  # POST /retailers.json
  def create
    @retailer = Retailer.new(retailer_params)

    respond_to do |format|
      if @retailer.save
        format.html { redirect_to @retailer, notice: 'Retailer was successfully created.' }
        format.json { render :show, status: :created, location: @retailer }
      else
        format.html { render :new }
        format.json { render json: @retailer.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    if @retailer.update(retailer_params)
        render :edit
    end
  end

  # DELETE /retailers/1
  # DELETE /retailers/1.json
  def destroy
    @retailer.destroy
    respond_to do |format|
      format.html { redirect_to retailers_url, notice: 'Retailer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retailer
      @retailer = Retailer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retailer_params
      params.require(:retailer).permit(:name, :contact_name, :contact_email, :notes, :regex_qty, 
      :regex_oos, :pref_currency, :billing_ad_line1, :billing_ad_line2, :billing_ad_city, 
      :billing_ad_postal_code, :billing_ad_country, :billing_ad_tel, 
      :fao_delivery, :delivery_ad_line1, :delivery_ad_line2, :delivery_ad_city, 
      :delivery_ad_postal_code, :delivery_ad_country, :delivery_ad_tel, :vatable, 
      :vat_number, :pref_shipping_provider, :pref_shipping_provider_ac_no, :pref_shipping_provider_shipping_type,
      :active, :show_foreign_sku, :is_retail, :logo_url, :logo_buy_url, :region_id,
      :mm_products_url, :base_url, :tax_region, :fao_billing, :nickname, :credit_days,
      :include_in_website)
    end
end
