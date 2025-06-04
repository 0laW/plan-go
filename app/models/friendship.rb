class Friendship < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id }
  validates :status, presence: true
  validate :not_duplicate

  def not_duplicate
    if Friendship.where(user_id: friend_id, friend_id: user_id).exists?
      errors.add(:base, "Friendship already exists.")
    end
  end
end
