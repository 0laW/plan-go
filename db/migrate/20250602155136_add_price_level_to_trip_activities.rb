class AddPriceLevelToTripActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :trip_activities, :price_level, :string
  end
end
