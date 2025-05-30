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
    password: "password123",
    user_image_url: "https://source.unsplash.com/100x100/?portrait,#{user[:first_name]}",
    username: user[:username]
  )
end

# Categories
beach = Category.create!(name: "Beach")
hiking = Category.create!(name: "Hiking")
food = Category.create!(name: "Food & Drink")
cultural = Category.create!(name: "Cultural")
entertainment = Category.create!(name: "Entertainment")
nature = Category.create!(name: "Nature & Outdoors")

# Define 4 countries with 4 activities each, different cities/places

country_activities = {
  "Japan" => [
    { name: "Kyoto Imperial Palace", location: "Kyoto", address: "Kyoto Gyoen, Kyoto", description: "Explore the historic Kyoto Imperial Palace", category: cultural },
    { name: "Tokyo Skytree", location: "Tokyo", address: "1 Chome-1-2 Oshiage, Sumida City, Tokyo", description: "Iconic broadcasting tower with city views", category: entertainment },
    { name: "Osaka Castle", location: "Osaka", address: "1-1 Osakajo, Chuo Ward, Osaka", description: "Historic castle with museum", category: cultural },
    { name: "Mount Fuji Hiking", location: "Shizuoka", address: "Mount Fuji, Shizuoka Prefecture", description: "Climb Japan's highest peak", category: hiking }
  ],
  "Greece" => [
    { name: "Acropolis", location: "Athens", address: "Athens 105 58", description: "Visit the iconic Acropolis and Parthenon", category: cultural },
    { name: "Santorini Beaches", location: "Santorini", address: "Santorini, Cyclades", description: "Relax on beautiful volcanic beaches", category: beach },
    { name: "Delphi Ruins", location: "Delphi", address: "Delphi, Greece", description: "Ancient religious sanctuary", category: cultural },
    { name: "Thessaloniki Food Tour", location: "Thessaloniki", address: "Thessaloniki, Greece", description: "Taste northern Greek cuisine", category: food }
  ],
  "USA" => [
    { name: "Statue of Liberty", location: "New York City", address: "Liberty Island, New York", description: "Visit the iconic symbol of freedom", category: cultural },
    { name: "Grand Canyon", location: "Arizona", address: "Grand Canyon National Park, AZ", description: "Explore the famous canyon", category: nature },
    { name: "Hollywood Walk of Fame", location: "Los Angeles", address: "Hollywood Blvd, Los Angeles", description: "Famous stars on the sidewalk", category: entertainment },
    { name: "Walt Disney World", location: "Orlando", address: "Orlando, Florida", description: "Massive theme park resort", category: entertainment }
  ],
  "Turkey" => [
    { name: "Hagia Sophia", location: "Istanbul", address: "Sultanahmet, Istanbul", description: "Historic Byzantine cathedral", category: cultural },
    { name: "Cappadocia Hot Air Balloon", location: "Cappadocia", address: "Cappadocia, Turkey", description: "Scenic hot air balloon rides", category: entertainment },
    { name: "Pamukkale Thermal Pools", location: "Pamukkale", address: "Pamukkale, Denizli", description: "Thermal mineral terraces", category: nature },
    { name: "Turkish Cuisine Experience", location: "Istanbul", address: "Istanbul, Turkey", description: "Taste authentic Turkish dishes", category: food }
  ]
}

all_activities = []

# Create activities, geocode them
country_activities.each do |country, acts|
  acts.each do |act|
    activity = Activity.create!(
      name: act[:name],
      location: act[:location],
      address: act[:address],
      description: act[:description],
      category: act[:category]
    )
    activity.geocode if activity.respond_to?(:geocode)
    activity.save!
    all_activities << activity
  end
end

# Helper method to create trips for user with activities from one country
def create_trip(user, country, activities, start_offset)
  trip = Trip.create!(
    location: country,
    start_date: Date.today - start_offset,
    end_date: Date.today - (start_offset - 5),
    budget: rand(800..2000),
    user: user
  )

  # Add all users to trip (social feature)
  User.all.each do |u|
    TripUser.create!(trip: trip, user: u)
  end

  # Add 4 activities per trip (all activities for that country)
  activities.each do |activity|
    TripActivity.create!(trip: trip, activity: activity)

    # Owner writes review
    ActivityReview.create!(
      user: user,
      activity: activity,
      rating: rand(4..5),
      comment: "Loved visiting #{activity.name}!",
      date: Date.today - (start_offset - rand(1..4))
    )
  end

  trip
end

puts "Creating trips for each user..."

user_records.each do |user|
  # Each user gets 1 or 2 trips randomly from the 4 countries
  chosen_countries = country_activities.keys.sample(rand(1..2))
  chosen_countries.each_with_index do |country, i|
    acts = all_activities.select { |a| country_activities[country].any? { |c_act| c_act[:name] == a.name } }
    create_trip(user, country, acts, 30 + i*7)
  end
end

puts "✅ Done seeding!"
