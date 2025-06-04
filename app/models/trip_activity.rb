class TripActivity < ApplicationRecord
  def day
    (start_time.to_date - trip.start_date).to_i + 1 if start_time && trip && trip.start_date
  end

  belongs_to :trip
  belongs_to :activity

  validates :start_time, :end_time, presence: true
end
