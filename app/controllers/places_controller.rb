require 'jbuilder'
class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    @places = Place.all
  end

  # GET /places/1
  # GET /places/1.json
  def show
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place.destroy
    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    personal_id = place_params[:personal_id]

    if Personal.find(personal_id)
      place_name = place_params[:name]
      place_address = place_params[:address]

      place = Place.new
      place.personal_id = personal_id
      place.name = place_name
      place.address = place_address
      place.latitude = 35.696361
      place.longitude = 139.771072
      place.save!

      out = Jbuilder.encode do |json|
        json.result do 
          json.status "ok"
          json.msg ""
          json.place place
        end
      end
      render json: out, status: :ok
    else
      out = Jbuilder.encode do |json|
        json.result do 
          json.status "error"
          json.msg "undefined personal data"
        end
      end
      render json: out, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:personal_id, :name, :address, :latitude, :longitude)
    end
end
