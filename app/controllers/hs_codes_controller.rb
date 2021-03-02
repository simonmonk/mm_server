class HsCodesController < ApplicationController
  before_action :set_hs_code, only: [:show, :edit, :update, :destroy]

  # GET /hs_codes
  # GET /hs_codes.json
  def index
    @hs_codes = HsCode.all
  end

  # GET /hs_codes/1
  # GET /hs_codes/1.json
  def show
  end

  # GET /hs_codes/new
  def new
    @hs_code = HsCode.new
  end

  # GET /hs_codes/1/edit
  def edit
  end

  # POST /hs_codes
  # POST /hs_codes.json
  def create
    @hs_code = HsCode.new(hs_code_params)

    respond_to do |format|
      if @hs_code.save
        format.html { redirect_to @hs_code, notice: 'Hs code was successfully created.' }
        format.json { render :show, status: :created, location: @hs_code }
      else
        format.html { render :new }
        format.json { render json: @hs_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hs_codes/1
  # PATCH/PUT /hs_codes/1.json
  def update
    respond_to do |format|
      if @hs_code.update(hs_code_params)
        format.html { redirect_to @hs_code, notice: 'Hs code was successfully updated.' }
        format.json { render :show, status: :ok, location: @hs_code }
      else
        format.html { render :edit }
        format.json { render json: @hs_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hs_codes/1
  # DELETE /hs_codes/1.json
  def destroy
    @hs_code.destroy
    respond_to do |format|
      format.html { redirect_to hs_codes_url, notice: 'Hs code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def extract_hs_codes_from_products
    @hs_codes = HsCode.all
    Product.all.each do | product |
      hs = product.harmoized_tarrif_number.strip
      puts hs
      if (not HsCode.find_by_code(hs))
        puts "adding code"
        HsCode.new(code: hs, notes: "found in product: " + product.name).save
      end
    end
    render :index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hs_code
      @hs_code = HsCode.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hs_code_params
      params.require(:hs_code).permit(:code, :nickname, :description, :url, :notes)
    end
end
