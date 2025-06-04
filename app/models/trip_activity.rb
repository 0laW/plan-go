class TripActivity < ApplicationRecord
  belongs_to :trip
  belongs_to :activity

  validates :start_time, :end_time, presence: true
end
