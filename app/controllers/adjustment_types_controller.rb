class AdjustmentTypesController < ApplicationController
  before_action :set_adjustment_type, only: [:show, :edit, :update, :destroy]

  # GET /adjustment_types
  # GET /adjustment_types.json
  def index
    @adjustment_types = AdjustmentType.all
  end

  # GET /adjustment_types/1
  # GET /adjustment_types/1.json
  def show
  end

  # GET /adjustment_types/new
  def new
    @adjustment_type = AdjustmentType.new
  end

  # GET /adjustment_types/1/edit
  def edit
  end

  # POST /adjustment_types
  # POST /adjustment_types.json
  def create
    @adjustment_type = AdjustmentType.new(adjustment_type_params)

    respond_to do |format|
      if @adjustment_type.save
        format.html { redirect_to @adjustment_type, notice: 'Adjustment type was successfully created.' }
        format.json { render :show, status: :created, location: @adjustment_type }
      else
        format.html { render :new }
        format.json { render json: @adjustment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adjustment_types/1
  # PATCH/PUT /adjustment_types/1.json
  def update
    respond_to do |format|
      if @adjustment_type.update(adjustment_type_params)
        format.html { redirect_to @adjustment_type, notice: 'Adjustment type was successfully updated.' }
        format.json { render :show, status: :ok, location: @adjustment_type }
      else
        format.html { render :edit }
        format.json { render json: @adjustment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustment_types/1
  # DELETE /adjustment_types/1.json
  def destroy
    @adjustment_type.destroy
    respond_to do |format|
      format.html { redirect_to adjustment_types_url, notice: 'Adjustment type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adjustment_type
      @adjustment_type = AdjustmentType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adjustment_type_params
      params.require(:adjustment_type).permit(:code, :name, :description)
    end
end
