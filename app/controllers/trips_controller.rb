class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
    @trips = current_user.trips
    @trip = Trip.new
  end

  def show
    @trip = current_user.trips.find(params[:id])
    @preferences = current_user.preferences.includes(:category, :subcategory)
    @activities = @trip.activities

    @ai_itinerary = AiItineraryGenerator.new(@trip).generate
  end

  def create
    @trip = current_user.trips.new(trip_params)

    if @trip.save
      redirect_to trip_path(@trip), notice: "Trip created!"
    else
      @trips = current_user.trips
      render :index, status: :unprocessable_entity
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:start_date, :end_date, :budget, :location)
  end
end
