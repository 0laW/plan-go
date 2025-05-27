class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :location
      t.decimal :rating
      t.string :description
      t.string :address
      t.string :name
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
