class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
    @trip = current_user.trips.build
    @trips = current_user.trips.order(created_at: :desc)
  end

  def create
    @trip = current_user.trips.new(trip_params)

    if @trip.save
      preferences = current_user.preferences.includes(:category, :subcategory)
      budget = @trip.budget.to_s.gsub(/[^\d\.]/, '') # clean budget input like "£40" to "40"
      AiItineraryGenerator.new(@trip, preferences, budget).generate
      redirect_to trip_path(@trip), notice: "Trip created!"
    else
      @trips = current_user.trips
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @preferences = current_user.preferences.includes(:category, :subcategory)
    @activities = Activity.order(created_at: :desc)
  end

  def remove_user
  @trip = Trip.find(params[:id])
  user_to_remove = User.find(params[:user_id])

  if current_user == @trip.user
    @trip.users.delete(user_to_remove)
    flash[:notice] = "#{user_to_remove.username} was removed from the trip."
  else
    flash[:alert] = "You are not authorized to remove users from this trip."
  end
  redirect_to trip_path(@trip)
end


  private

  def trip_params
    params.require(:trip).permit(:start_date, :end_date, :start_time, :end_time, :location, :budget)
  end
end
