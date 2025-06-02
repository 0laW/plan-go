class TripActivitiesController < ApplicationController
  def index
  end
  def show
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.find(params[:id])
  end
  def new
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.new
  end
  def create 
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.new(activity_params)
    if @activity.save
      redirect_to trip_activity_path(@trip, @activity), notice: 'Activity was successfully created.'
    else
      render :new
    end
  end
  def edit
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.find(params[:id])
  end
  def update
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.find(params[:id])
    if @activity.update(activity_params)
      redirect_to trip_activity_path(@trip, @activity), notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end
  def destroy
    @trip = Trip.find(params[:trip_id])
    @activity = @trip.activities.find(params[:id])
    @activity.destroy
    redirect_to trip_path(@trip), notice: 'Activity was successfully deleted.'
  end
  private
  def activity_params
    params.require(:activity).permit(:name, :description, :start_time, :end_time, :location_id)
  end
  def set_trip
    @trip = Trip.find(params[:trip_id])
  end
  def set_activity
    @activity = @trip.activities.find(params[:id])
  end
  def trip_activities_params
    params.require(:trip_activity).permit(:trip_id, :activity_id)
  end
  def trip_activity_params
    params.require(:trip_activity).permit(:trip_id, :activity_id, :name, :description, :start_time, :end_time, :location_id)
  end
end
