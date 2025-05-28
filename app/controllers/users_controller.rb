class UsersController < ApplicationController
  def index
    @trips = Trip.geocoded.includes(:user)

    @markers = @trips.geocoded.map do |trip|
      {
        lat: trip.latitude,
        lng: trip.longitude
      }
    end
  end
  def show
    @user = User.find(params[:id])
  end
end
