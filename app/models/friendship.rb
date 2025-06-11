class Friendship < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id }
  validates :status, presence: true
  validate :not_duplicate

  after_create :create_friend_request_notification
  after_update :create_accepted_notification, if: :accepted?

  private

  def not_duplicate
    if Friendship.where(user_id: friend_id, friend_id: user_id).exists?
      errors.add(:base, "Friendship already exists.")
    end
  end

  def create_friend_request_notification
    Notification.create!(
      user: friend,
      notifiable: self,
      notification_type: "friend_request"
    )
  end

  def create_accepted_notification
    Notification.create!(
      user: user,
      notifiable: self,
      notification_type: "friend_accepted"
    )
  end
end
