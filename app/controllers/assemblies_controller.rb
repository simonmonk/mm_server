class AssembliesController < ApplicationController
  before_action :set_assembly, only: [:show, :edit, :update, :destroy, :stock_label]
    skip_before_filter :verify_authenticity_token 

  # GET /assemblies
  # GET /assemblies.json
  def index
    @assemblies = Assembly.all
  end

  # GET /assemblies/1
  # GET /assemblies/1.json
  def show
  end

  # GET /assemblies/new
  def new
    @assembly = Assembly.new
    @assembly.active = true
    @assembly.qty = 0
    @assembly.stock_warning_level = 0
  end

  # GET /assemblies/1/edit
  def edit
  end
    
  def deduct_stock
      assembly_id = params['assembly_id']
      n = params['qty'].to_i
      assembly = Assembly.find(assembly_id)
      assembly.assembly_parts.each do |ap|
        ap.part.qty = ap.part.qty - ap.qty * n
        ap.part.save
      end
      assembly.qty = assembly.qty + n
      assembly.save
      t = Transaction.new
      t.transaction_type = 'Deduct Stock for Assembly'
      t.description = "Removed parts from stock to make " + n.to_s + " new " + assembly.name
      t.save
      redirect_to :action => "edit", :id => assembly_id
  end
      
    
  def stock_report
  end

  def stock_label
    render :layout => false
  end
    
  def add_part
    part_id = params[:part_id]
    assembly_id = params[:assembly_id]
    qty = params[:qty].to_i
    results = AssemblyPart.where(part_id: part_id, assembly_id: assembly_id)
    if (results.length > 0)
        ap = results[0]
        ap.qty = ap.qty + qty
        ap.save
    else
        ap = AssemblyPart.new(:part_id => part_id, :assembly_id => assembly_id, :qty => qty)
        ap.save
    end
    redirect_to :action => "edit", :id => assembly_id
  end
    
  def delete_part
    assembly_part_id = params[:assembly_part_id]
    ass_part = AssemblyPart.find(assembly_part_id)
    assembly_id = ass_part.assembly.id
    ass_part.destroy
    redirect_to :action => "edit", :id => assembly_id
  end
    

  def create
    @assembly = Assembly.new(assembly_params)
    if @assembly.save
        redirect_to @assembly, notice: 'Product was successfully created.'
    else
        render :new
    end
  end

  
  def update
    if @assembly.update(assembly_params)
        render :edit
    end
  end

  # DELETE /assemblies/1
  # DELETE /assemblies/1.json
  def destroy
    @assembly.destroy
    respond_to do |format|
      format.html { redirect_to assemblies_url, notice: 'Assembly was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assembly
      @assembly = Assembly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assembly_params
      params.require(:assembly).permit(:name, :qty, :labour, :stock_warning_level, :active, :assembly_category_id)
    end
end
