class User < ApplicationRecord
  has_many :preferences
  has_many :trips

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :activity_reviews
  has_many :trips
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true

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
end
