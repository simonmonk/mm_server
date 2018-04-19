class ProductRetailersController < ApplicationController
  before_action :set_product_retailer, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token  

  # GET /product_retailers
  # GET /product_retailers.json
  def index
    @product_retailers = ProductRetailer.all
  end

  # GET /product_retailers/1
  # GET /product_retailers/1.json
  def show
  end

  # GET /product_retailers/new
  def new
    @product_retailer = ProductRetailer.new
  end

  # GET /product_retailers/1/edit
  def edit
  end

  # POST /product_retailers
  # POST /product_retailers.json
  def create
    @product_retailer = ProductRetailer.new(product_retailer_params)

    respond_to do |format|
      if @product_retailer.save
        format.html { redirect_to @product_retailer, notice: 'Product retailer was successfully created.' }
        format.json { render :show, status: :created, location: @product_retailer }
      else
        format.html { render :new }
        format.json { render json: @product_retailer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_retailers/1
  # PATCH/PUT /product_retailers/1.json
  def update
    if @product_retailer.update(product_retailer_params)
        render :edit
    end
  end

  # DELETE /product_retailers/1
  # DELETE /product_retailers/1.json
  def destroy
    @product_retailer.destroy
    respond_to do |format|
      format.html { redirect_to product_retailers_url, notice: 'Product retailer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_retailer
      @product_retailer = ProductRetailer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_retailer_params
      params.require(:product_retailer).permit(:url, :sku)
    end
end
