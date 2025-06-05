class AddPriceLevelToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :price_level, :string
  end
end
