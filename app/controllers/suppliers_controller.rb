class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /suppliers
  def index
    @suppliers = Supplier.all
  end

  # GET /suppliers/suppliers_list
  def suppliers_list
    @suppliers = Supplier.all.order(:name)
    render :json => @suppliers
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    @supplier.active = true
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Supplier was successfully created.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
      if @supplier.update(supplier_params)
        redirect_to :action => "edit", :id =>@supplier.id
      end   
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:name, :contact_name, :contact_email, :notes, :regex_qty, 
      :regex_oos, :website, :active, :login_details, :payment_details, 
      :product_url_base, :tax_region)
    end
end
