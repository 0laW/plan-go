class SearchController < ApplicationController
  def index
    @query = params[:q]
    # Example: search across models
    @trips = Trip.where("location ILIKE :q OR budget ILIKE :q", q: "%#{@query}%")
    @users = User.where("username ILIKE ?", "%#{@query}%")
    @activities = Activity.where("name ILIKE ?", "%#{@query}%")
    # Add more as needed
  end
end
