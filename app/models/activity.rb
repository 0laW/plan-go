class Activity < ApplicationRecord
  belongs_to :category
  has_many :trip_reviews
  has_many :activity_reviews
  has_many :trip_activities
  has_many :trips, through: :trip_activities

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
