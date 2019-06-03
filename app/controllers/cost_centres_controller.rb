class CostCentresController < ApplicationController
  before_action :set_cost_centre, only: [:show, :edit, :update, :destroy]

  # GET /cost_centres
  # GET /cost_centres.json
  def index
    @cost_centres = CostCentre.all
  end

  # GET /cost_centres/1
  # GET /cost_centres/1.json
  def show
  end

  # GET /cost_centres/new
  def new
    @cost_centre = CostCentre.new
  end

  # GET /cost_centres/1/edit
  def edit
  end

  # POST /cost_centres
  # POST /cost_centres.json
  def create
    @cost_centre = CostCentre.new(cost_centre_params)

    respond_to do |format|
      if @cost_centre.save
        format.html { redirect_to @cost_centre, notice: 'Cost centre was successfully created.' }
        format.json { render :show, status: :created, location: @cost_centre }
      else
        format.html { render :new }
        format.json { render json: @cost_centre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_centres/1
  # PATCH/PUT /cost_centres/1.json
  def update
    respond_to do |format|
      if @cost_centre.update(cost_centre_params)
        format.html { redirect_to @cost_centre, notice: 'Cost centre was successfully updated.' }
        format.json { render :show, status: :ok, location: @cost_centre }
      else
        format.html { render :edit }
        format.json { render json: @cost_centre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_centres/1
  # DELETE /cost_centres/1.json
  def destroy
    @cost_centre.destroy
    respond_to do |format|
      format.html { redirect_to cost_centres_url, notice: 'Cost centre was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_centre
      @cost_centre = CostCentre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_centre_params
      params.require(:cost_centre).permit(:name, :code)
    end
end
