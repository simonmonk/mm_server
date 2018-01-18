class RetailersController < ApplicationController
  before_action :set_retailer, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /retailers
  # GET /retailers.json
  def index
    @retailers = Retailer.all
  end

  # GET /retailers/1
  # GET /retailers/1.json
  def show
  end

  # GET /retailers/new
  def new
    @retailer = Retailer.new
  end

  # GET /retailers/1/edit
  def edit
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

  # PATCH/PUT /retailers/1
  # PATCH/PUT /retailers/1.json
  def update
    respond_to do |format|
      if @retailer.update(retailer_params)
        format.html { redirect_to @retailer, notice: 'Retailer was successfully updated.' }
        format.json { render :show, status: :ok, location: @retailer }
      else
        format.html { render :edit }
        format.json { render json: @retailer.errors, status: :unprocessable_entity }
      end
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
      params.require(:retailer).permit(:name, :contact_name, :contact_email, :notes, :regex_qty, :regex_oos)
    end
end
