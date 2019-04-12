class CommunicationsController < ApplicationController
  before_action :set_communication, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  # GET /communications
  # GET /communications.json
  def index
    @communications = Communication.all
  end

  # GET /communications/1
  # GET /communications/1.json
  def show
  end

  # GET /communications/new
  def new
    @communication = Communication.new
  end

  # GET /communications/1/edit
  def edit
  end

  # POST /communications
  # POST /communications.json
  def create
    @communication = Communication.new(communication_params)

    respond_to do |format|
      if @communication.save
        format.html { redirect_to @communication, notice: 'Communication was successfully created.' }
        format.json { render :show, status: :created, location: @communication }
      else
        format.html { render :new }
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communications/1
  # PATCH/PUT /communications/1.json
  def update
    respond_to do |format|
      if @communication.update(communication_params)
        format.html { redirect_to @communication, notice: 'Communication was successfully updated.' }
        format.json { render :show, status: :ok, location: @communication }
      else
        format.html { render :edit }
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communications/1
  # DELETE /communications/1.json
  def destroy
    @communication.destroy
    respond_to do |format|
      format.html { redirect_to communications_url, notice: 'Communication was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_communication
      @communication = Communication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def communication_params
      params.require(:communication).permit(:prospect_id, :communication_date, :user_id, :notes, :email_url)
    end
end
