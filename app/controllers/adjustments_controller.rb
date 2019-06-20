class AdjustmentsController < ApplicationController
  before_action :set_adjustment, only: [:show, :edit, :update, :destroy]

  # GET /adjustments
  # GET /adjustments.json
  def index
    @adjustments = Adjustment.all.order(:adjustment_date)
  end

  # GET /adjustments/1
  # GET /adjustments/1.json
  def show
  end

  # GET /adjustments/new
  def new
    @adjustment = Adjustment.new
  end

  # GET /adjustments/1/edit
  def edit
  end

  # POST /adjustments
  # POST /adjustments.json
  def create
    @adjustment = Adjustment.new(adjustment_params)

    respond_to do |format|
      if @adjustment.save
        @adjustments = Adjustment.all
        format.html { render :index}
        format.json { render :show, status: :created, location: @adjustment }
      else
        format.html { render :new }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adjustments/1
  # PATCH/PUT /adjustments/1.json
  def update
    respond_to do |format|
      if @adjustment.update(adjustment_params)
        @adjustments = Adjustment.all
        format.html { render :index}
        format.json { render :show, status: :ok, location: @adjustment }
      else
        format.html { render :edit }
        format.json { render json: @adjustment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjustments/1
  # DELETE /adjustments/1.json
  def destroy
    @adjustment.destroy
    respond_to do |format|
      format.html { redirect_to adjustments_url, notice: 'Adjustment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adjustment
      @adjustment = Adjustment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adjustment_params
      params.require(:adjustment).permit(:adjustment_date, :value, :adjustment_type, :description, :organisation, :vat_value, :tax_region)
    end
end
