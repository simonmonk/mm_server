class PartsController < ApplicationController
  before_action :set_part, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token 

  # GET /parts
  # GET /parts.json
  def index
    @parts = Part.all.order(name: :asc)
  end
    
  def export_parts
    @parts = Part.all.order(name: :asc)
  end

  # GET /parts/1
  # GET /parts/1.json
  def show
  end

  # GET /parts/new
  def new
    @part = Part.new
    @categories = PartCategory.all
  end

  # GET /parts/1/edit
  def edit
    @categories = PartCategory.all
  end
    
def add_supplier
    supplier_id = params[:supplier_id]
    part_id = params[:part_id]
    code = params[:code]
    pp = PartSupplier.new(:part_id => part_id, :supplier_id => supplier_id, :code => code)
    pp.save
    redirect_to :action => "edit", :id => part_id
end
    
def remove_part_supplier
    part_supplier_id = params[:part_supplier_id].to_i
    part_id = params[:part_id].to_i
    pp = PartSupplier.find(part_supplier_id)
    if (pp)
        pp.delete()
    end
    redirect_to :action => "edit", :id => part_id
end


  # POST /parts
  # POST /parts.json
  def create
    @part = Part.new(part_params)
    if @part.save
      redirect_to :action => "edit", :id => @part.id
        #render :edit
    else
        render :new
    end
  end

  def update
      if @part.update(part_params)
        #redirect_to :action => "index", notice: 'Part was successfully updated.'  
        render :edit
      else
        render :edit
      end
  end

  # DELETE /parts/1
  # DELETE /parts/1.json
  def destroy
    @part.destroy
    respond_to do |format|
      format.html { redirect_to parts_url, notice: 'Part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part
      @part = Part.find(params[:id])
      @categories = PartCategory.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_params
      params.require(:part).permit(:name, :part_category_id, :active, :qty, :cost, :currency, :exch_rate, :stock_warning_level, :shipping_cost, :notes)
    end
end
