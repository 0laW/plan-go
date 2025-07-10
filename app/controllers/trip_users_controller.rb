class TripUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    trip = Trip.find(params[:trip_id])
    user = User.find(params[:user_id])

    # Only trip owner or participant can add users
    unless trip.user == current_user || trip.users.include?(current_user)
      return head :forbidden
    end

    # Prevent duplicate association
    if trip.users.include?(user)
      return render json: { error: "User already added" }, status: :unprocessable_entity
    end

    # Create the join record
    TripUser.create!(trip: trip, user: user)

    # Return response
    render json: {
      user_id: user.id,
      username: user.username,
      user_image_url: user.user_image_url
    }, status: :ok
  end
end
