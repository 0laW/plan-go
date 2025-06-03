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

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @trips = @user.trips
  end

  # app/controllers/users_controller.rb
  def search_users
    user = User.find_by(username: params[:username])

    render json: {}, status: :not_found and return if user.nil?

    trips = user.trips.includes(trip_activities: { activity: %i[category activity_reviews] })

    markers = trips.flat_map do |trip|
      trip.trip_activities.map do |trip_activity|
        activity = trip_activity.activity

        next unless activity.latitude.present? && activity.longitude.present?

        {
          lat: activity.latitude,
          lng: activity.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: {
                                               activity: activity,
                                               trip: trip,
                                               reviews: activity.activity_reviews.where(user: user)
                                             }),
          marker_html: render_to_string(partial: "marker", locals: { trip: trip })
        }
      end
    end.compact

    center = markers.any? ? [markers.first[:lng], markers.first[:lat]] : [0, 51]

    user_info_html = render_to_string(
      partial: "users/info_box",
      locals: { user: user, trips: trips }
    )

    render json: {
      center: center,
      markers: markers,
      user: {
        id: user.id,
        username: user.username,
        trip_count: trips.count,
        trip_names: trips.pluck(:location),
        review_count: user.activity_reviews.count,
        level: user.level
      },
      user_info_html: user_info_html
    }
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully!'
    else
      render :edit
    end
  end

  private

  def username_param
    params[:username].to_s.strip.downcase
  end

  def user_params
    params.require(:user).permit(:username, :email, :user_image)
  end

  def load_user_trips
    @trips = @user.trips.includes(trip_activities: { activity: %i[category activity_reviews] }).geocoded

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
