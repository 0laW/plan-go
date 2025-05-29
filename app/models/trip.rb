class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_activities
  has_many :activities, through: :trip_activities

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end
