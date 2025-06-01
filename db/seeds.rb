puts "🌱 Seeding..."

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

# --- USERS ---

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

# --- CATEGORIES AND SUBCATEGORIES ---

categories_with_subs = [
  { name: "🎨 Cultural", subcategories: ["🖼️ Art Museums", "🏛️ Historic Sites", "🎨 Street Art"] },
  { name: "☕ Food & Drink", subcategories: ["🍜 Local Cuisine", "☕ Coffee Shops", "🍻 Bars & Pubs"] },
  { name: "🎭 Entertainment", subcategories: ["🎶 Live Music", "🎟️ Theatre", "🤣 Comedy Shows"] },
  { name: "🌿 Nature & Outdoors", subcategories: ["🥾 Hiking Trails", "🌳 Parks", "🏖️ Beaches"] },
  { name: "🛍️ Shopping", subcategories: ["👗 Boutiques", "🛒 Markets", "🏬 Malls"] },
  { name: "🧘 Wellness", subcategories: ["💆 Spas", "🧘 Yoga", "♨️ Hot Springs"] },
  { name: "🎯 Experience Types", subcategories: ["🎨 Workshops", "🚌 Tours", "🎉 Festivals"] }
]

category_records = categories_with_subs.map do |cat|
  category = Category.create!(name: cat[:name])
  cat[:subcategories].each do |sub_name|
    Subcategory.create!(name: sub_name, category: category)
  end
  category
end

# --- ACTIVITIES ---

country_activities = {
  "Japan" => [
    { name: "Kyoto Imperial Palace", location: "Kyoto", address: "Kyoto Gyoen, Kyoto", description: "Explore the historic Kyoto Imperial Palace", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Tokyo Skytree", location: "Tokyo", address: "1 Chome-1-2 Oshiage, Sumida City, Tokyo", description: "Iconic broadcasting tower with city views", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Osaka Castle", location: "Osaka", address: "1-1 Osakajo, Chuo Ward, Osaka", description: "Historic castle with museum", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Mount Fuji Hiking", location: "Shizuoka", address: "Mount Fuji, Shizuoka Prefecture", description: "Climb Japan's highest peak", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } }
  ],
  "Greece" => [
    { name: "Acropolis", location: "Athens", address: "Athens 105 58", description: "Visit the iconic Acropolis and Parthenon", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Santorini Beaches", location: "Santorini", address: "Santorini, Cyclades", description: "Relax on beautiful volcanic beaches", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Delphi Ruins", location: "Delphi", address: "Delphi, Greece", description: "Ancient religious sanctuary", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Thessaloniki Food Tour", location: "Thessaloniki", address: "Thessaloniki, Greece", description: "Taste northern Greek cuisine", category: category_records.find { |c| c.name.include?("Food & Drink") } }
  ],
  "USA" => [
    { name: "Statue of Liberty", location: "New York City", address: "Liberty Island, New York", description: "Visit the iconic symbol of freedom", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Grand Canyon", location: "Arizona", address: "Grand Canyon National Park, AZ", description: "Explore the famous canyon", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Hollywood Walk of Fame", location: "Los Angeles", address: "Hollywood Blvd, Los Angeles", description: "Famous stars on the sidewalk", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Walt Disney World", location: "Orlando", address: "Orlando, Florida", description: "Massive theme park resort", category: category_records.find { |c| c.name.include?("Entertainment") } }
  ],
  "Turkey" => [
    { name: "Hagia Sophia", location: "Istanbul", address: "Sultanahmet, Istanbul", description: "Historic Byzantine cathedral", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Cappadocia Hot Air Balloon", location: "Cappadocia", address: "Cappadocia, Turkey", description: "Scenic hot air balloon rides", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Pamukkale Thermal Pools", location: "Pamukkale", address: "Pamukkale, Denizli", description: "Thermal mineral terraces", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Turkish Cuisine Experience", location: "Istanbul", address: "Istanbul, Turkey", description: "Taste authentic Turkish dishes", category: category_records.find { |c| c.name.include?("Food & Drink") } }
  ]
}

all_activities = []

country_activities.each do |country, acts|
  acts.each do |act|
    activity = Activity.create!(
      name: act[:name],
      location: act[:location],
      address: act[:address],
      description: act[:description],
      category: act[:category]
    )
    if activity.respond_to?(:geocode)
      activity.geocode
      activity.save!
    end
    all_activities << activity
  end
end

# --- Helper to create trips ---

def create_trip(user, country, activities, start_offset)
  trip = Trip.create!(
    location: country,
    start_date: Date.today - start_offset,
    end_date: Date.today - (start_offset - 5),
    budget: rand(800..2000),
    user: user
  )

  # Add all users to the trip (social feature)
  User.all.each do |u|
    TripUser.create!(trip: trip, user: u)
  end

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
  chosen_countries = country_activities.keys.sample(rand(1..2))
  chosen_countries.each_with_index do |country, i|
    acts = all_activities.select { |a| country_activities[country].any? { |c_act| c_act[:name] == a.name } }
    create_trip(user, country, acts, 30 + i * 7)
  end
end

puts "✅ Done seeding!"
