class PartCategoriesController < ApplicationController
  before_action :set_part_category, only: [:show, :edit, :update, :destroy]

  # GET /part_categories
  # GET /part_categories.json
  def index
    @part_categories = PartCategory.all
  end

  # GET /part_categories/1
  # GET /part_categories/1.json
  def show
  end

  # GET /part_categories/new
  def new
    @part_category = PartCategory.new
  end

  # GET /part_categories/1/edit
  def edit
  end

  # POST /part_categories
  # POST /part_categories.json
  def create
    @part_category = PartCategory.new(part_category_params)

    respond_to do |format|
      if @part_category.save
        format.html { redirect_to @part_category, notice: 'Part category was successfully created.' }
        format.json { render :show, status: :created, location: @part_category }
      else
        format.html { render :new }
        format.json { render json: @part_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /part_categories/1
  # PATCH/PUT /part_categories/1.json
  def update
    respond_to do |format|
      if @part_category.update(part_category_params)
        format.html { redirect_to @part_category, notice: 'Part category was successfully updated.' }
        format.json { render :show, status: :ok, location: @part_category }
      else
        format.html { render :edit }
        format.json { render json: @part_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /part_categories/1
  # DELETE /part_categories/1.json
  def destroy
    @part_category.destroy
    respond_to do |format|
      format.html { redirect_to part_categories_url, notice: 'Part category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_part_category
      @part_category = PartCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def part_category_params
      params.require(:part_category).permit(:name)
    end
end
