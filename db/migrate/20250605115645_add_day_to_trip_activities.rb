class AddDayToTripActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :trip_activities, :day, :integer
  end
end
