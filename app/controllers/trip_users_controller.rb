class TripUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    trip = Trip.find(params[:trip_id])
    user = User.find(params[:user_id])

    unless trip.user == current_user || trip.users.include?(current_user)
      return head :forbidden
    end

    if trip.users.include?(user)
      render json: { error: "User already added" }, status: :unprocessable_entity and return
    end

    trip_user = TripUser.create!(trip: trip, user: user)

    render json: {
      user_id: user.id,
      username: user.username,
      user_image_url: user.user_image_url
    }, status: :ok
  end

    trip.users << user

    render json: {
      user_id: user.id,
      username: user.username,
      user_image_url: user.user_image_url
    }
  end
end
