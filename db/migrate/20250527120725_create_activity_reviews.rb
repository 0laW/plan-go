class CreateActivityReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :rating
      t.text :comment
      t.date :date
      t.references :activity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
