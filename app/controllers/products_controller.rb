class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :catalog, :print_labels, :stock_label]
    skip_before_filter :verify_authenticity_token 

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.where(active: true).order(:product_category_id)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @categories = ProductCategory.all
    @product = Product.new
    @product.sku = @product.find_next_sku
    @product.active = true
    @product.qty = 0
    @product.stock_warning_level = 0
    @product.wholesale_price = 0
    @product.retail_price = 0  
    @product.weight_g = 0
    @product.labour = 0
    @product.product_category_id = 1
  end

  # GET /products/1/edit
  def edit
      if (not @product.weight_g)
          @product.weight_g = 0
      end
  end
    
  def pricelist
      render :layout => false
  end

  def pricelist_csv
    render :layout => false
  end

  def image_links
    render :layout => false
  end

  def productlist
    render :layout => false
  end
    
  def sales_by_product
  end

  def sales_report
  end

  def stock_label
    render :layout => false
  end

  def product_id_from_barcode
    barcode = params['barcode']
    product = Product.find_by(barcode_value: '0' + barcode)
    render json: product.id
  end

  def print_labels
    render :layout => false
  end


  # deduct quatities of all the parts and assemblies used for qty of this product.
  def deduct_stock
      product_id = params['product_id']
      n = params['qty'].to_i
      product = Product.find(product_id)
      product.deduct_stock(n)
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
    
  def delete_assembly
    product_assembly_id = params[:product_assembly_id]
    prod_assembly = ProductAssembly.find(product_assembly_id)
    product_id = prod_assembly.product.id
    prod_assembly.destroy
    redirect_to :action => "edit", :id => product_id
  end
    
  def bring_all_prices_inline_with_catalog
    Product.bring_all_prices_inline_with_catalog
    redirect_to :action => "index"
  end

  # POST /products
  # POST /products.json
  def create
      @product = Product.new(product_params)
      if (product_params['barcode'])
        filename = product_params['barcode'].original_filename
        if (filename and filename.length > 4)
            @product.barcode_value = filename[0..-5]
        end
      end

    if @product.save
        redirect_to :action => "edit", :id => @product.id, notice: 'Product was successfully created.' 
    else
        render :new 
    end
  end


  def update
      if (product_params['barcode'])
        filename = product_params['barcode'].original_filename
        if (filename and filename.length > 4)
            @product.barcode_value = filename[0..-5]
        end
      end
      if @product.update(product_params)
        render :edit, notice: 'Product was successfully updated.' 
      else
        render :edit
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
      @categories = ProductCategory.all
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :product_category_id, :active, 
        :qty, :sku, :labour, :stock_warning_level, :wholesale_price, 
        :retail_price, :wholesale_price_usd, :retail_price_usd, 
        :harmoized_tarrif_number, :country_of_origin, :short_description, 
        :long_description, :product_photo_uri, :customs_description, 
        :include_in_catalog, :release_date, :product_url, :weight_g, 
        :barcode, :barcode_value, :high_res_image_share, :new_in_catalog,
        :new_price_in_catalog, :end_of_line_in_catalog, :rohs_compliant,
        :catalog_priority, :carousel_0, :carousel_1, :carousel_2, :carousel_3,
        :carousel_4, :tutorial_url, :datasheet_url, :video_url_0, :video_url_1, 
        :video_url_2, :instructions_url, :compatability_image, :wholesale_price_catalog, 
        :retail_price_catalog, :lessons_url, :hs_code_id
      )
    end
end
