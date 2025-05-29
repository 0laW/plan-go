class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]

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

  def show
    @user = User.find(params[:id])
  end

  def search_users
    user = User.find_by(username: params[:username].to_s.strip.downcase)
    return render json: { error: "User not found" }, status: :not_found unless user

    trips = user.trips.includes(trip_activities: { activity: [:category, :activity_reviews] }).geocoded

    activities = trips.flat_map(&:trip_activities).map(&:activity).select do |a|
      a.latitude.present? && a.longitude.present?
    end

    return render json: { error: "No geocoded activities found for this user" }, status: :not_found if activities.empty?

    markers = activities.map do |activity|
      trip = activity.trip_activities.first&.trip
      {
        lat: activity.latitude,
        lng: activity.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {
          activity: activity,
          trip: trip,
          reviews: activity.activity_reviews.where(user: user)
        }),
        marker_html: render_to_string(partial: "marker", locals: {
          trip: trip
        })
      }
    end

    center = [activities.first.longitude, activities.first.latitude]

    render json: {
      center: center,
      markers: markers
    }
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
          marker_html: render_to_string(partial: "marker", locals: { trip: trip })
        }
      end
    end.compact
  end
end
