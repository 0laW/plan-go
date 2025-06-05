class AddCostToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :cost, :integer
  end
end
