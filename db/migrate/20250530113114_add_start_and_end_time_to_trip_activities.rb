class AddStartAndEndTimeToTripActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :trip_activities, :start_time, :datetime
    add_column :trip_activities, :end_time, :datetime
  end
end
