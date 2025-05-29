class UsersController < ApplicationController
  def index
    if username_param.present?
      @user = User.find_by(username: username_param)

      if @user
        load_user_trips
      else
        @trips = []
        flash.now[:alert] = "User not found"
      end
    else
      @trips = []
    end
  end

  private

  def username_param
    params[:username].to_s.strip.downcase
  end

  def load_user_trips
    @trips = @user.trips.includes(trip_activities: { activity: [:category, :activity_reviews] }).geocoded

    @markers = @trips.flat_map do |trip|
      trip.trip_activities.map do |ta|
        activity = ta.activity

        next unless activity.latitude.present? && activity.longitude.present?

        {
          lat: activity.latitude,
          lng: activity.longitude,
          info_window_html: render_to_string(
            partial: "info_window",
            locals: {
              activity: activity,
              trip: trip,
              reviews: activity.activity_reviews.where(user: @user)
            }
          ),
          marker_html: render_to_string(partial: "marker", locals: {
            trip: trip
          })
        }
      end
    end.compact
  end
  puts "@markers: #{@markers.inspect}"
  def show
    @user = User.find(params[:id])
  end
end
