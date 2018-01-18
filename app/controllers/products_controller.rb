class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
    skip_before_filter :verify_authenticity_token 

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end
    
def deduct_stock
      product_id = params['product_id']
      n = params['qty'].to_i
      product = Product.find(product_id)
      product.product_parts.each do |pp|
        pp.part.qty = pp.part.qty - pp.qty * n
        pp.part.save
      end
      product.product_assemblies.each do |pp|
        pp.assembly.qty = pp.assembly.qty - pp.qty * n
        pp.assembly.save
      end
      product.qty = product.qty + n
      product.save
      t = Transaction.new
      t.transaction_type = 'Deduct Stock for Product'
      t.description = "Removed parts and assemblies from stock to make " + n.to_s + " new " + product.name
      t.save
      redirect_to :action => "edit", :id => product_id
end    
    
def add_part
    part_id = params[:part_id]
    product_id = params[:product_id]
    qty = params[:qty].to_i
    results = ProductPart.where(part_id: part_id, product_id: product_id)
    if (results.length > 0)
        pp = results[0]
        pp.qty = pp.qty + qty
        pp.save
    else
        pp = ProductPart.new(:part_id => part_id, :product_id => product_id, :qty => qty)
        pp.save
    end
    redirect_to :action => "edit", :id => product_id
end
    
def delete_part
    product_part_id = params[:product_part_id]
    prod_part = ProductPart.find(product_part_id)
    product_id = prod_part.product.id
    prod_part.destroy
    redirect_to :action => "edit", :id => product_id
end
    
def add_assembly
    assembly_id = params[:assembly_id]
    product_id = params[:product_id]
    qty = params[:qty].to_i
    results = ProductAssembly.where(assembly_id: assembly_id, product_id: product_id)
    if (results.length > 0)
        pp = results[0]
        pp.qty = pp.qty + qty
        pp.save
    else
        pp = ProductAssembly.new(:assembly_id => assembly_id, :product_id => product_id, :qty => qty)
        pp.save
    end
    redirect_to :action => "edit", :id => product_id
end
    
    

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
      if @product.update(product_params)
        redirect_to @product, notice: 'Product was successfully updated.'
      end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :active, :qty, :sku, :labour, :stock_warning_level, :wholesale_price, :retail_price, )
    end
end
