# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding..."

# Clear existing data
ActivityReview.destroy_all
TripActivity.destroy_all
TripUser.destroy_all
Preference.destroy_all
Activity.destroy_all
Category.destroy_all
Trip.destroy_all
User.destroy_all

# Users
users = [
  { first_name: "Diego", last_name: "Colina", username: "diegoc" },
  { first_name: "Sumaiya", last_name: "Shaikh", username: "sumaiya" },
  { first_name: "Alex", last_name: "Cercel", username: "alexc" },
  { first_name: "Ola", last_name: "Wilk", username: "olaw" },
  { first_name: "Jordan", last_name: "Gilbert", username: "jordang" }
]

users.each do |user|
  User.create!(
    first_name: user[:first_name],
    last_name: user[:last_name],
    email: "#{user[:first_name].downcase}@example.com",
    password: "123456",
    user_image_url: "https://source.unsplash.com/100x100/?portrait,#{user[:first_name]}",
    username: user[:username]
  )
end

# Categories
beach = Category.create!(name: "Beach")
hiking = Category.create!(name: "Hiking")
food = Category.create!(name: "Food & Drink")

# Activities
activity1 = Activity.create!(
  name: "Bondi Beach Surfing",
  location: "Sydney",
  address: "Bondi Beach, NSW",
  description: "Surf lessons at Bondi Beach",
  rating: 4.7,
  category: beach
)

activity2 = Activity.create!(
  name: "Blue Mountains Hike",
  location: "Katoomba",
  address: "Echo Point Rd, Katoomba",
  description: "Hiking trail in Blue Mountains",
  rating: 4.9,
  category: hiking
)

# Preferences (adding for Jordan and Diego)
user_jordan = User.find_by(first_name: "Jordan")
user_diego = User.find_by(first_name: "Diego")

Preference.create!(user: user_jordan, category: beach)
Preference.create!(user: user_jordan, category: food)
Preference.create!(user: user_diego, category: hiking)

# Trip (owned by Jordan)
trip = Trip.create!(
  location: "Australia Adventure",
  start_date: Date.today,
  end_date: Date.today + 10,
  budget: "1000",
  user: user_jordan
)

# Trip Users (everyone joins the trip)
User.all.each do |user|
  TripUser.create!(trip: trip, user: user)
end

# Trip Activities
TripActivity.create!(trip: trip, activity: activity1)
TripActivity.create!(trip: trip, activity: activity2)

# Activity Reviews
ActivityReview.create!(
  user: user_jordan,
  activity: activity1,
  rating: 4.5,
  comment: "Great surfing session!",
  date: Date.today - 2
)

ActivityReview.create!(
  user: user_diego,
  activity: activity2,
  rating: 5.0,
  comment: "Epic views and great hike.",
  date: Date.today - 1
)

puts "✅ Done seeding!"
