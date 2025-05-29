class AddSubcategoryIdToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_column :preferences, :subcategory_id, :bigint
  end
end
