class TripUser < ApplicationRecord
  belongs_to :trip
  belongs_to :user

  after_create :notify_user_added

  def notify_user_added
    Notification.create!(
      user: user,
      notifiable: self,
      notification_type: "added_to_trip"
    )
  end
end
