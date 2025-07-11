class User < ApplicationRecord
  AVATAR_URLS = [
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946312/duck_uzatea.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946487/giraffe_iz6dir.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946487/panda-bear_k5x6yb.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/dragon_vsob23.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/penguin_selpzx.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/dog_v3wmnw.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/jaguar_atrb2w.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/hippopotamus_jbd2vd.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946493/bear_pt8nwf.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748946493/koala_zt8cxo.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748947149/goat_jmp9oi.png",
    "https://res.cloudinary.com/dpekautsm/image/upload/v1748947148/wolf_ydwzua.png"
  ]

  before_create :assign_random_avatar

  has_many :preferences
  has_many :trips

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activity_reviews
  has_many :trips
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :trip_users
  has_many :participated_trips, through: :trip_users, source: :trip

  has_many :notifications, dependent: :destroy

  def confirmed_friends
    friends = friendships.where(status: 'accepted').map(&:friend)
    inverse = inverse_friendships.where(status: 'accepted').map(&:user)
    (friends + inverse).uniq
  end

  def pending_friend_requests
    inverse_friendships.where(status: 'pending')
  end

  def sent_requests
    friendships.where(status: 'pending')
  end

  def friend_with?(other_user)
    Friendship.exists?(user: self, friend: other_user, status: 'accepted') ||
      Friendship.exists?(user: other_user, friend: self, status: 'accepted')
  end

  def level
    points = (activity_reviews.count * 2) + (trips.count * 5)
    case points
    when 0..2 then "Wanderer"
    when 3..5 then "Explorer"
    when 6..8 then "Trailblazer"
    when 9..12 then "Pathfinder"
    when 13..16 then "Wayfarer"
    when 17..21 then "Adventurer"
    when 22..27 then "Globetrotter"
    when 28..34 then "Trailmaster"
    when 35..42 then "Nomad"
    else "World Conqueror"
    end
  end

  private

  def assign_random_avatar
    self.user_image_url ||= AVATAR_URLS.sample
  end
end
