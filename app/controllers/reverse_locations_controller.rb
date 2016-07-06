class ReverseLocationsController < ApplicationController
  before_action :set_reverse_location, only: [:show, :edit, :update, :destroy]

  # GET /reverse_locations
  # GET /reverse_locations.json
  def index
    @reverse_locations = ReverseLocation.all
  end

  # GET /reverse_locations/1
  # GET /reverse_locations/1.json
  def show
  end

  # GET /reverse_locations/new
  def new
    @reverse_location = ReverseLocation.new
  end

  # GET /reverse_locations/1/edit
  def edit
  end

  # POST /reverse_locations
  # POST /reverse_locations.json
  def create
    @reverse_location = ReverseLocation.new(reverse_location_params)

    respond_to do |format|
      if @reverse_location.save
        format.html { redirect_to @reverse_location, notice: 'Reverse location was successfully created.' }
        format.json { render :show, status: :created, location: @reverse_location }
      else
        format.html { render :new }
        format.json { render json: @reverse_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reverse_locations/1
  # PATCH/PUT /reverse_locations/1.json
  def update
    respond_to do |format|
      if @reverse_location.update(reverse_location_params)
        format.html { redirect_to @reverse_location, notice: 'Reverse location was successfully updated.' }
        format.json { render :show, status: :ok, location: @reverse_location }
      else
        format.html { render :edit }
        format.json { render json: @reverse_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reverse_locations/1
  # DELETE /reverse_locations/1.json
  def destroy
    @reverse_location.destroy
    respond_to do |format|
      format.html { redirect_to reverse_locations_url, notice: 'Reverse location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reverse_location
      @reverse_location = ReverseLocation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reverse_location_params
      params.require(:reverse_location).permit(:address, :latitude, :longitude)
    end
end
