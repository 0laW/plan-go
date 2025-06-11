class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def mark_as_read
  notification = current_user.notifications.find(params[:id])
  notification.update(read: true)
  respond_to do |format|
    format.turbo_stream
    format.html { redirect_to notifications_path }
  end
end

end
