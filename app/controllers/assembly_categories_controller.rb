class AssemblyCategoriesController < ApplicationController
  before_action :set_assembly_category, only: [:show, :edit, :update, :destroy]

  # GET /assembly_categories
  # GET /assembly_categories.json
  def index
    @assembly_categories = AssemblyCategory.all
  end

  # GET /assembly_categories/1
  # GET /assembly_categories/1.json
  def show
  end

  # GET /assembly_categories/new
  def new
    @assembly_category = AssemblyCategory.new
  end

  # GET /assembly_categories/1/edit
  def edit
  end

  # POST /assembly_categories
  # POST /assembly_categories.json
  def create
    @assembly_category = AssemblyCategory.new(assembly_category_params)

    respond_to do |format|
      if @assembly_category.save
        format.html { redirect_to @assembly_category, notice: 'Assembly category was successfully created.' }
        format.json { render :show, status: :created, location: @assembly_category }
      else
        format.html { render :new }
        format.json { render json: @assembly_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assembly_categories/1
  # PATCH/PUT /assembly_categories/1.json
  def update
    respond_to do |format|
      if @assembly_category.update(assembly_category_params)
        format.html { redirect_to @assembly_category, notice: 'Assembly category was successfully updated.' }
        format.json { render :show, status: :ok, location: @assembly_category }
      else
        format.html { render :edit }
        format.json { render json: @assembly_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assembly_categories/1
  # DELETE /assembly_categories/1.json
  def destroy
    @assembly_category.destroy
    respond_to do |format|
      format.html { redirect_to assembly_categories_url, notice: 'Assembly category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assembly_category
      @assembly_category = AssemblyCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assembly_category_params
      params.require(:assembly_category).permit(:name, :priority)
    end
end
