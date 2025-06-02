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
"China" => [
    { name: "Great Wall of China", location: "Beijing", address: "Huairou, Beijing", description: "Walk along the iconic Great Wall", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Terracotta Army", location: "Xi'an", address: "Lintong District, Xi'an", description: "Ancient clay soldiers guarding a tomb", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Giant Panda Breeding Center", location: "Chengdu", address: "Chengdu, Sichuan", description: "See pandas up close", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Li River Cruise", location: "Guilin", address: "Guilin, Guangxi", description: "Scenic river cruise with karst mountains", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Shanghai Tower", location: "Shanghai", address: "Shanghai Tower, Lujiazui, Shanghai", description: "Visit the tallest skyscraper in China", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Forbidden City", location: "Beijing", address: "Dongcheng, Beijing", description: "Historic imperial palace complex", category: category_records.find { |c| c.name.include?("Cultural") } }
  ],
  "Thailand" => [
    { name: "Grand Palace", location: "Bangkok", address: "Na Phra Lan Rd, Bangkok", description: "Historic palace and temple complex", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Phi Phi Islands", location: "Krabi", address: "Phi Phi Islands, Krabi", description: "Beautiful island beaches and snorkeling", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Floating Market", location: "Damnoen Saduak", address: "Ratchaburi Province", description: "Traditional Thai floating market", category: category_records.find { |c| c.name.include?("Shopping") } },
    { name: "Chiang Mai Night Bazaar", location: "Chiang Mai", address: "Chang Khlan Rd, Chiang Mai", description: "Popular night market with crafts and food", category: category_records.find { |c| c.name.include?("Shopping") } },
    { name: "Wat Arun Temple", location: "Bangkok", address: "Wat Arun, Bangkok", description: "Beautiful riverside temple", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Thai Cooking Class", location: "Bangkok", address: "Various locations", description: "Learn to cook traditional Thai food", category: category_records.find { |c| c.name.include?("Experience Types") } }
  ],
  "Japan" => [
    { name: "Kyoto Imperial Palace", location: "Kyoto", address: "Kyoto Gyoen, Kyoto", description: "Explore the historic Kyoto Imperial Palace", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Tokyo Skytree", location: "Tokyo", address: "1 Chome-1-2 Oshiage, Sumida City, Tokyo", description: "Iconic broadcasting tower with city views", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Osaka Castle", location: "Osaka", address: "1-1 Osakajo, Chuo Ward, Osaka", description: "Historic castle with museum", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Mount Fuji Hiking", location: "Shizuoka", address: "Mount Fuji, Shizuoka Prefecture", description: "Climb Japan's highest peak", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Senso-ji Temple", location: "Tokyo", address: "2 Chome-3-1 Asakusa, Taito City, Tokyo", description: "Ancient Buddhist temple", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Shibuya Crossing", location: "Tokyo", address: "Shibuya, Tokyo", description: "Famous pedestrian scramble", category: category_records.find { |c| c.name.include?("Entertainment") } }
  ],
  "Australia" => [
    { name: "Sydney Opera House", location: "Sydney", address: "Bennelong Point, Sydney", description: "World-famous performing arts center", category: category_records.find { |c| c.name.include?("Entertainment") } },
    { name: "Great Barrier Reef", location: "Queensland", address: "Queensland Coast", description: "Snorkeling and diving in the reef", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Uluru", location: "Northern Territory", address: "Uluru-Kata Tjuta National Park", description: "Massive sandstone monolith", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Bondi Beach", location: "Sydney", address: "Bondi, Sydney", description: "Famous surfing beach", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Melbourne Laneways", location: "Melbourne", address: "Melbourne CBD", description: "Explore street art and cafes", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Tasmania Wilderness", location: "Tasmania", address: "Tasmania", description: "Untouched natural parks", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } }
  ],
  "Switzerland" => [
    { name: "Matterhorn", location: "Zermatt", address: "Zermatt, Valais", description: "Iconic mountain peak", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Lake Geneva Cruise", location: "Geneva", address: "Lake Geneva, Geneva", description: "Scenic boat cruise", category: category_records.find { |c| c.name.include?("Nature & Outdoors") } },
    { name: "Château de Chillon", location: "Montreux", address: "Montreux, Vaud", description: "Medieval lakeside castle", category: category_records.find { |c| c.name.include?("Cultural") } },
    { name: "Jungfrau Railway", location: "Bernese Oberland", address: "Bernese Oberland", description: "Mountain railway with spectacular views", category: category_records.find { |c| c.name.include?("Experience Types") } },
    { name: "Zurich Old Town", location: "Zurich", address: "Zurich", description: "Historic city center with shops and cafes", category: category_records.find { |c| c.name.include?("Shopping") } },
    { name: "Swiss Fondue Experience", location: "Bern", address: "Bern", description: "Taste traditional Swiss fondue", category: category_records.find { |c| c.name.include?("Food & Drink") } }
  ]
}

activity_records = []

country_activities.each do |country, activities|
  activities.each do |activity_attrs|
    act = Activity.create!(
      name: activity_attrs[:name],
      location: activity_attrs[:location],
      address: activity_attrs[:address],
      description: activity_attrs[:description],
      category: activity_attrs[:category],
      image_url: "https://source.unsplash.com/400x300/?#{activity_attrs[:name].parameterize}"
    )
    act.geocode if act.respond_to?(:geocode)
    activity_records << { country: country, activity: act }
  end
end

puts "Created #{activity_records.count} activities."

def avg_lat_lon(activities)
  lats = activities.map(&:latitude).compact
  lons = activities.map(&:longitude).compact
  if lats.any? && lons.any?
    [lats.sum / lats.size, lons.sum / lons.size]
  else
    [nil, nil]
  end
end

trip_countries = country_activities.keys

trip_records = []

user_records.each do |user|
  trip_count = rand(1..2)
  trip_countries.sample(trip_count).each do |country|
    country_acts = activity_records.select { |h| h[:country] == country }.map { |h| h[:activity] }

    # Here's the change: always pick 10 activities or max available
    selected_activities = country_acts.sample([10, country_acts.size].min)

    start_date = Date.today - rand(60..120)
    end_date = start_date + rand(5..15)
    budget = %w[low medium high].sample

    trip = Trip.create!(
      start_date: start_date,
      end_date: end_date,
      location: country,
      budget: budget,
      user: user
    )

    selected_activities.each do |activity|
      TripActivity.create!(
        trip: trip,
        activity: activity,
        start_time: start_date.to_datetime + rand(9..17).hours,
        end_time: start_date.to_datetime + rand(18..22).hours
      )
    end

    lat, lon = avg_lat_lon(selected_activities)
    trip.update(latitude: lat, longitude: lon) if lat && lon

    review_count = [selected_activities.size, 3].min
    selected_activities.sample(review_count).each do |activity|
      ActivityReview.create!(
        activity: activity,
        user: user,
        rating: rand(3.0..5.0).round(1),
        comment: ["Great experience!", "Highly recommend!", "Loved it!", "Would do it again!", "Amazing!"].sample,
        date: trip.start_date + rand(0..(trip.end_date - trip.start_date).to_i)
      )
    end
    trip_records << trip
  end
end

puts "Created #{trip_records.count} trips."

# --- PREFERENCES ---
subcategory_records = Subcategory.all.to_a

user_records.each do |user|
  subcats = subcategory_records.sample(rand(2..4))
  subcats.each do |subcat|
    Preference.create!(
      user: user,
      category: subcat.category,
      subcategory: subcat
    )
  end
end

puts "Seeding complete."
