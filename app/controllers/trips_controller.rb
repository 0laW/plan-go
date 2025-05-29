class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
if current_user
    @trips = current_user.trips
  else
    @trips = Trip.none
  end
  @trip = Trip.new
end

  def show
    @preferences = current_user.preferences.includes(:category, :subcategory)
    @trip = current_user.trips.find(params[:id])
  end

  def create
    @trip = current_user.trips.new(trip_params)

    if @trip.save
      redirect_to trip_path(@trip)
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
