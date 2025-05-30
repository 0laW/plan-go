class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find(params[:id])
    @stops = @trip.stops.includes(:location)
  end

  def new
    @trip = Trip.new
  end

  def current_page
    @trip = Trip.find(params[:id])
    @stops = @trip.stops.includes(:location)
  end

  def create

  end

  private

end
          