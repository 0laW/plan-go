
puts "🌱 Seeding..."

require 'dotenv/load'

puts "Cleaning the DB..."

ActivityReview.destroy_all
TripActivity.destroy_all
TripUser.destroy_all
Preference.destroy_all
Activity.destroy_all
Subcategory.destroy_all
Category.destroy_all
Trip.destroy_all
User.destroy_all

puts "Seeding..."

# Users
users = [
  { first_name: "Diego", last_name: "Colina", username: "diegoc" },
  { first_name: "Sumaiya", last_name: "Shaikh", username: "sumaiya" },
  { first_name: "Alex", last_name: "Cercel", username: "alexc" },
  { first_name: "Ola", last_name: "Wilk", username: "olaw" },
  { first_name: "Jordan", last_name: "Gilbert", username: "jordang" }
]

user_records = users.map do |user|
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

# Preferences
user_jordan = User.find_by(first_name: "Jordan")
user_diego = User.find_by(first_name: "Diego")

Preference.create!(user: user_jordan, category: beach)
Preference.create!(user: user_jordan, category: food)
Preference.create!(user: user_diego, category: hiking)

# Trip
trip = Trip.create!(
  location: "Australia Adventure",
  start_date: Date.today,
  end_date: Date.today + 10,
  budget: "1000",
  user: user_jordan
)

User.all.each do |user|
  TripUser.create!(trip: trip, user: user)
end

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
activities = [
  { name: "Bondi Beach Surfing", location: "Sydney", address: "Queen Elizabeth Dr, Bondi Beach NSW 2026, Australia", description: "Surf lessons at Bondi Beach", rating: 4.7, category: beach },
  { name: "Blue Mountains Hike", location: "Katoomba", address: "23-31 Echo Point Rd, Katoomba NSW 2780, Australia", description: "Hiking trail in Blue Mountains", rating: 4.9, category: hiking },
  { name: "Sydney Food Tour", location: "Sydney", address: "Haymarket NSW 2000, Australia", description: "Explore food markets and cafes", rating: 4.6, category: food },
  { name: "Manly Beach Day", location: "Manly", address: "North Steyne, Manly NSW 2095, Australia", description: "Relax and enjoy the beach", rating: 4.4, category: beach },
  { name: "Coastal Cliff Walk", location: "Coogee", address: "Arden St, Coogee NSW 2034, Australia", description: "Scenic walk with ocean views", rating: 4.8, category: hiking }
]

activity_records = activities.map do |attrs|
  activity = Activity.create!(attrs)
  activity.geocode
  activity.save!
  activity
end

# Preferences
Preference.create!(user: user_records[4], category: beach)
Preference.create!(user: user_records[4], category: food)
Preference.create!(user: user_records[0], category: hiking)

# Helper to generate trips
def create_trip_for(user, location, activities, start_offset)
  trip = Trip.create!(
    location: location,
    start_date: Date.today - start_offset,
    end_date: Date.today - (start_offset - 3),
    budget: rand(500..1500).to_s,
    user: user
  )

  # Add all users to trip
  User.all.each do |u|
    TripUser.create!(trip: trip, user: u)
  end

  # Add some activities
  activities.sample(2).each do |activity|
    TripActivity.create!(trip: trip, activity: activity)

    # Add a review from the trip owner
    ActivityReview.create!(
      user: user,
      activity: activity,
      rating: rand(4.0..5.0).round(1),
      comment: "Loved this place! #{activity.name}",
      date: Date.today - (start_offset - 1)
    )
  end

  trip
end

# Give each user 1-2 trips
locations = ["Australia Adventure", "Mountain Getaway", "City Foodie Tour", "Beach Bliss", "Wilderness Retreat"]
user_records.each_with_index do |user, i|
  create_trip_for(user, locations[(i % locations.size)], activity_records, (10 + (i * 5)))
  create_trip_for(user, "#{locations[(i % locations.size)]} Part 2", activity_records, (20 + (i * 5))) if (i.even?)
end

# High-level Categories + Subcategories
categories = [
  { name: "🎨 Cultural", subcategories: ["🖼️ Art Museums", "🏛️ Historic Sites", "🎨 Street Art"] },
  { name: "☕ Food & Drink", subcategories: ["🍜 Local Cuisine", "☕ Coffee Shops", "🍻 Bars & Pubs"] },
  { name: "🎭 Entertainment", subcategories: ["🎶 Live Music", "🎟️ Theatre", "🤣 Comedy Shows"] },
  { name: "🌿 Nature & Outdoors", subcategories: ["🥾 Hiking Trails", "🌳 Parks", "🏖️ Beaches"] },
  { name: "🛍️ Shopping", subcategories: ["👗 Boutiques", "🛒 Markets", "🏬 Malls"] },
  { name: "🧘 Wellness", subcategories: ["💆 Spas", "🧘 Yoga", "♨️ Hot Springs"] },
  { name: "🎯 Experience Types", subcategories: ["🎨 Workshops", "🚌 Tours", "🎉 Festivals"] }
]

categories.each do |cat_data|
  category = Category.create!(name: cat_data[:name])
  cat_data[:subcategories].each do |sub_name|
    Subcategory.create!(name: sub_name, category: category)
  end
end
puts "✅ Done seeding!"

# Clear existing
Category.where(name: ['Style', 'Personality']).destroy_all

style = Category.create!(name: 'Style')
personality = Category.create!(name: 'Personality')

# Style subcategories
style_subcats = [
  "Off-the-beaten-path / Iconic Must-Sees",
  "Photo-worthy spots",
  "Budget / Luxury",
  "Solo / Social",
  "LGBTQ+ Friendly",
  "Pet-Friendly",
  "Kid-Friendly"
]

style_subcats.each do |name|
  Subcategory.create!(name: name, category: style)
end

# Personality subcategories
personality_subcats = [
  "Chill",
  "Curious",
  "Out All Night",
  "Learn something",
  "Eat well",
  "Vibes",
  "Insta moments"
]

personality_subcats.each do |name|
  Subcategory.create!(name: name, category: personality)
end

puts "✅ Done seeding!"
