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

avatar_urls = [
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946312/duck_uzatea.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946487/giraffe_iz6dir.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946487/panda-bear_k5x6yb.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/dragon_vsob23.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/penguin_selpzx.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/dog_v3wmnw.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/jaguar_atrb2w.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946488/hippopotamus_jbd2vd.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946493/bear_pt8nwf.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748946493/koala_zt8cxo.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748947149/goat_jmp9oi.png",
  "https://res.cloudinary.com/dpekautsm/image/upload/v1748947148/wolf_ydwzua.png"
]

user_records = users.map do |user|
  User.create!(
    first_name: user[:first_name],
    last_name: user[:last_name],
    email: "#{user[:first_name].downcase}@example.com",
    password: "password123",
    user_image_url: "#{avatar_urls.sample}",
    username: user[:username]
  )

end

# --- CATEGORIES AND SUBCATEGORIES ---
categories_with_subs = [
  {
    name: "Cultural",
    subcategories: [
      "History Museums",
      "Art Galleries",
      "Street Art",
      "Historic Sites",
      "Monuments",
      "Architectural Sites",
      "Religious Sites",
      "Local Markets",
      "Walking City Tours",
      "Bus City Tours",
      "Boat Tours",
      "Language Exchange"
    ]
  },
  {
    name: "Food & Drink",
    subcategories: [
      "Local Cuisine",
      "Michelin Star Restaurants",
      "Street Food",
      "Wine Bars / Tasting",
      "Craft Beer",
      "Cocktail Bars",
      "Brunch",
      "Bakeries",
      "Speciality Coffee",
      "Food Festivals",
      "Cooking Workshops"
    ]
  },
  {
    name: "Entertainment",
    subcategories: [
      "Live Music",
      "Jazz Bars",
      "Theatre",
      "Cinema",
      "Nightlife",
      "Music Festivals",
      "Art Festivals",
      "Art Fairs",
      "Flea Markets",
      "Comedy",
      "Waterparks"
    ]
  },
  {
    name: "Nature & Outdoors",
    subcategories: [
      "Parks",
      "Botanical Gardens",
      "Beaches",
      "Lakes",
      "Viewpoints",
      "Hiking Trails",
      "Nature Walks",
      "Biking Paths"
    ]
  },
  {
    name: "Shopping",
    subcategories: [
      "Vintage Stores",
      "Thrift Shops",
      "Designer Fashion",
      "Vinyl / Record Shops",
      "Bookstores",
      "Independent Boutiques",
      "Shopping Malls"
    ]
  },
  {
    name: "Wellness",
    subcategories: [
      "Spas",
      "Hot Springs",
      "Meditation Centers",
      "Beauty Salons"
    ]
  },
  {
    name: "Preferences",
    subcategories: [
      "Walking",
      "Cycling",
      "E-Bike / Scooter",
      "Tram",
      "Bus",
      "Train",
      "Metro",
      "Early Riser",
      "Night Owl",
      "Breakfast Lover",
      "Healthy Eater"
    ]
  }
]
category_records = categories_with_subs.map do |cat|
  category = Category.create!(name: cat[:name]) # name includes emoji!
  cat[:subcategories].each do |sub_name|
    Subcategory.create!(name: sub_name, category: category)
  end
  category
end

# --- ACTIVITIES ---
country_activities = {
  "Japan" => {
  "Tokyo" => [
    { name: "Tokyo Skytree Observation Deck", address: "Sumida City, Tokyo", description: "360° panoramic city views and photo opportunities", category: "Cultural", subcategory: "Viewpoints" },
    { name: "Jiro's Sushi Honten", address: "Ginza, Tokyo", description: "World-famous sushi master experience", category: "Food & Drink", subcategory: "Michelin Star Restaurants" },
    { name: "Shibuya Sky Rooftop", address: "Shibuya, Tokyo", description: "Perfect aerial shots of famous crossing", category: "Cultural", subcategory: "Viewpoints" },
    { name: "Golden Gai Bar Hopping", address: "Kabukicho, Shinjuku, Tokyo", description: "Tiny themed bars in narrow alleys", category: "Food & Drink", subcategory: "Cocktail Bars" },
    { name: "TeamLab Borderless Digital Art", address: "Odaiba, Tokyo", description: "Immersive digital installations and surreal visuals", category: "Entertainment", subcategory: "Art Festivals" },
    { name: "Tsukiji Fish Market Food Tour", address: "Tsukiji, Tokyo", description: "Tuna auction and sushi breakfast from market stalls", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Meiji Shrine Photo Walk", address: "Shibuya, Tokyo", description: "Traditional shrine in forested park with photo ops", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Harajuku Street Fashion Hunt", address: "Harajuku, Tokyo", description: "Vibrant youth fashion and independent boutiques", category: "Shopping", subcategory: "Independent Boutiques" },
    { name: "Robot Restaurant Show", address: "Kabukicho, Shinjuku, Tokyo", description: "Neon, robots, and sensory overload performances", category: "Entertainment", subcategory: "Nightlife" },
    { name: "Cherry Blossom Hanami Party", address: "Ueno Park, Tokyo", description: "Picnic and sake under pink petals in full bloom", category: "Nature & Outdoors", subcategory: "Parks" }
  ],
  "Kyoto" => [
    { name: "Fushimi Inari Shrine Gates", address: "Fushimi Ward, Kyoto", description: "10,000 vermillion gates winding up mountain trails", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kikunoi Kaiseki Dinner", address: "Higashiyama Ward, Kyoto", description: "Michelin three-star seasonal tasting journey", category: "Food & Drink", subcategory: "Michelin Star Restaurants" },
    { name: "Arashiyama Bamboo Grove", address: "Arashiyama, Kyoto", description: "Dreamlike bamboo forest perfect for morning walks", category: "Nature & Outdoors", subcategory: "Nature Walks" },
    { name: "Traditional Tea Ceremony", address: "Gion District, Kyoto", description: "Ceremonial matcha served in tranquil teahouse", category: "Cultural", subcategory: "Local Markets" },
    { name: "Kinkaku-ji Golden Pavilion", address: "Kita Ward, Kyoto", description: "Glowing reflection shots of famous golden temple", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Pontocho Alley Dining", address: "Nakagyo Ward, Kyoto", description: "Historic riverside alley with terrace dining", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Kiyomizu-dera Temple Views", address: "Higashiyama Ward, Kyoto", description: "Wooden balcony with panoramic Kyoto city views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Nishiki Market Crawl", address: "Nakagyo Ward, Kyoto", description: "Tasting skewers, sweets, and street eats", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Gion Geisha Photo Tour", address: "Gion District, Kyoto", description: "Cultural walk with glimpses of geisha in kimonos", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Philosopher's Path Cherry Walk", address: "Sakyo Ward, Kyoto", description: "Tranquil cherry-lined canal trail in spring", category: "Nature & Outdoors", subcategory: "Nature Walks" }
  ],
  "Osaka" => [
    { name: "Osaka Castle Spring Photos", address: "Chuo Ward, Osaka", description: "Cherry blossoms surrounding iconic white castle", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Dotonbori Neon Night Walk", address: "Chuo Ward, Osaka", description: "Famous signs and bridges in nightlife epicenter", category: "Entertainment", subcategory: "Nightlife" },
    { name: "Kuromon Market Food Crawl", address: "Nipponbashi, Osaka", description: "Try local seafood, wagyu skewers, and fruit mochi", category: "Food & Drink", subcategory: "Street Food" },
    { name: "Umeda Sky Building Viewpoint", address: "Kita Ward, Osaka", description: "Floating observatory deck with sunset skyline", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Takoyaki Cooking Workshop", address: "Namba, Osaka", description: "Make your own octopus balls with locals", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Shinsaibashi Shopping Arcade", address: "Chuo Ward, Osaka", description: "Boutiques, fashion chains, and café stops", category: "Shopping", subcategory: "Independent Boutiques" },
    { name: "Sumiyoshi Taisha Morning Visit", address: "Sumiyoshi Ward, Osaka", description: "Oldest Shinto shrine with arched bridge photo op", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Spa World Onsen Day", address: "Naniwa Ward, Osaka", description: "Theme-park-style hot springs from around the globe", category: "Wellness", subcategory: "Hot Springs" },
    { name: "Hozenji Yokocho Hidden Alley", address: "Chuo Ward, Osaka", description: "Candle-lit alley with mossy statue and yakitori", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Osaka Bay Evening Cruise", address: "Minato Ward, Osaka", description: "Lit-up cityscape from ferry deck at night", category: "Entertainment", subcategory: "Boat Tours" }
  ],
  "Hiroshima" => [
    { name: "Peace Memorial Photo Stop", address: "Naka Ward, Hiroshima", description: "Symbolic A-Bomb Dome and eternal flame", category: "Cultural", subcategory: "Monuments" },
    { name: "Miyajima Floating Torii Shot", address: "Itsukushima Island", description: "Red gate standing in sea at high tide", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Hiroshima-style Okonomiyaki Class", address: "Hiroshima City", description: "Learn to layer pancake and toppings", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Miyajima Deer Park", address: "Miyajima Island", description: "Freely roaming sacred deer near shrine", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Hiroshima Castle at Night", address: "Naka Ward, Hiroshima", description: "Illuminated replica castle and moat", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Shukkeien Garden Tea Stop", address: "Naka Ward, Hiroshima", description: "Miniature landscape garden with tea pavilions", category: "Wellness", subcategory: "Meditation Centers" },
    { name: "Mazda Factory Tour", address: "Aki District, Hiroshima", description: "Inside look at Japanese car production", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Mitaki-dera Forest Trail", address: "Nishi Ward, Hiroshima", description: "Hike through waterfalls to hidden mountain temple", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Island Boat Excursion", address: "Hiroshima Bay", description: "Visit lesser-known islands on scenic ferry loop", category: "Nature & Outdoors", subcategory: "Boat Tours" },
    { name: "Okonomimura Food Hall", address: "Naka Ward, Hiroshima", description: "Four floors of sizzling okonomiyaki booths", category: "Food & Drink", subcategory: "Local Cuisine" }
  ],
  "Nara" => [
    { name: "Todai-ji Daibutsu Visit", address: "Nara Park", description: "See the Great Buddha in wooden temple hall", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Deer Selfie Time", address: "Nara City", description: "Pose with the sacred deer of Nara Park", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Kasuga Taisha Lantern Path", address: "Nara Park", description: "Stone and bronze lanterns lit in magical glow", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kofuku-ji Pagoda Photos", address: "Nara Park", description: "Five-story wooden pagoda from 8th century", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kaiseki at Mahoroba", address: "Nara City", description: "Elegant seasonal tasting menu with local ingredients", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Sake Brewery Crawl", address: "Naramachi District", description: "Historic district with traditional sake tastings", category: "Food & Drink", subcategory: "Wine Bars / Tasting" },
    { name: "Isuien Garden Walk", address: "Nara City", description: "Seasons and borrowed scenery in peaceful garden", category: "Nature & Outdoors", subcategory: "Botanical Gardens" },
    { name: "Mount Wakakusa Hike", address: "Nara Park", description: "Gentle climb for panoramic city and forest views", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Buddhist Art Museum Visit", address: "Nara Park", description: "Rare relics and sculpture exhibitions", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Yoshikien Garden Tour", address: "Nara City", description: "Photography-friendly gardens with changing colors", category: "Cultural", subcategory: "Walking City Tours" }
    ]
  },
  "Thailand" => {
    "Bangkok" => [
    { name: "Grand Palace Golden Spires", address: "Na Phra Lan Rd, Bangkok", description: "Intricate Thai architecture perfect for detail shots", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Gaggan Progressive Indian Cuisine", address: "Silom, Bangkok", description: "One of Asia’s top restaurants for molecular Indian dishes", category: "Food & Drink", subcategory: "Michelin Star Restaurants" },
    { name: "Wat Arun Temple Climb", address: "Thonburi, Bangkok", description: "The Temple of Dawn offering panoramic city and river views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Chatuchak Market Treasure Hunt", address: "Chatuchak District, Bangkok", description: "Thousands of stalls offering crafts, vintage finds, and street snacks", category: "Cultural", subcategory: "Local Markets" },
    { name: "Khao San Road Food Crawl", address: "Phra Nakhon District, Bangkok", description: "Bustling backpacker strip famous for street eats", category: "Food & Drink", subcategory: "Street Food" },
    { name: "Jim Thompson House Museum", address: "Pathum Wan District, Bangkok", description: "Historic home of silk entrepreneur showcasing Southeast Asian art", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Chao Phraya River Cruise", address: "Chao Phraya River, Bangkok", description: "Evening boat ride past illuminated temples and palaces", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Lumpini Park Tai Chi Session", address: "Pathum Wan District, Bangkok", description: "Join locals for morning movement and calm in nature", category: "Wellness", subcategory: "Meditation Centers" },
    { name: "Bangkok Thai Cooking Class", address: "Various locations, Bangkok", description: "Market shopping and hands-on cooking of Thai classics", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Sky Bar at Lebua State Tower", address: "Silom, Bangkok", description: "Sky-high cocktails and skyline views from a world-famous bar", category: "Food & Drink", subcategory: "Cocktail Bars" }
  ],
    "Chiang Mai" => [
    { name: "Doi Suthep Temple Visit", address: "Mueang Chiang Mai District", description: "Golden mountaintop temple overlooking Chiang Mai", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Chiang Mai Night Bazaar", address: "Chang Khlan Rd, Chiang Mai", description: "Handmade crafts, silver jewelry, and food stalls", category: "Cultural", subcategory: "Local Markets" },
    { name: "Elephant Nature Park Visit", address: "Mae Taeng District, Chiang Mai", description: "Rescue center focused on ethical elephant care", category: "Nature & Outdoors", subcategory: "Nature Walks" },
    { name: "Old City Temple Walking Tour", address: "Chiang Mai Old City", description: "Explore ancient temples on foot inside old city walls", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Sunday Walking Street Market", address: "Ratchadamnoen Rd, Chiang Mai", description: "Arts, crafts, and street performances", category: "Cultural", subcategory: "Local Markets" },
    { name: "Doi Inthanon National Park Hike", address: "Chom Thong District, Chiang Mai", description: "Waterfalls and viewpoints in Thailand's highest peak", category: "Nature & Outdoors", subcategory: "Viewpoints" },
    { name: "Khantoke Dinner & Dance Show", address: "Various venues, Chiang Mai", description: "Northern Thai cuisine paired with cultural dance", category: "Entertainment", subcategory: "Art Festivals" },
    { name: "Sticky Waterfall Hike", address: "Mae Taeng District, Chiang Mai", description: "Unique climbable limestone waterfall", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Hill Tribe Homestay Experience", address: "Various locations, Chiang Mai", description: "Cultural immersion with local hill tribes", category: "Cultural", subcategory: "Local Markets" },
    { name: "Zoe in Yellow Bar Crawl", address: "Nimmanhaemin Rd, Chiang Mai", description: "Chiang Mai’s liveliest nightlife hub", category: "Entertainment", subcategory: "Nightlife" }
  ],
    "Phuket" => [
    { name: "Patong Beach Sunset Walk", address: "Kathu District, Phuket", description: "Golden hour on Phuket’s busiest beach", category: "Nature & Outdoors", subcategory: "Beaches" },
    { name: "Mom Tri's Boathouse", address: "Kata Beach, Phuket", description: "Elegant beachfront fine dining", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Big Buddha Viewpoint", address: "Chalong, Phuket", description: "Giant hilltop statue with panoramic views", category: "Cultural", subcategory: "Monuments" },
    { name: "Phi Phi Islands Boat Trip", address: "Phi Phi Islands", description: "Day trip with snorkeling and limestone cliffs", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Phuket Old Town Photo Walk", address: "Mueang Phuket District", description: "Colorful Sino-Portuguese shophouses and murals", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Phuket FantaSea Show", address: "Kamala Beach, Phuket", description: "Large-scale Thai culture-themed performance", category: "Entertainment", subcategory: "Theatre" },
    { name: "Kata Beach Surfing Session", address: "Kata, Phuket", description: "Surf-friendly beach for beginners", category: "Nature & Outdoors", subcategory: "Beaches" },
    { name: "Bangla Road Night Out", address: "Patong, Phuket", description: "Loud nightlife scene with bars and neon chaos", category: "Entertainment", subcategory: "Nightlife" },
    { name: "James Bond Island Kayak Tour", address: "Phang Nga Bay", description: "Paddle through sea caves and limestone towers", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Blue Elephant Cooking School", address: "Phuket Town", description: "Gourmet cooking class in historic setting", category: "Food & Drink", subcategory: "Cooking Workshops" }
  ],
    "Krabi" => [
    { name: "Railay Beach Climbing", address: "Railay Peninsula, Krabi", description: "Climb dramatic limestone cliffs by the sea", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Tiger Cave Temple Hike", address: "Mueang Krabi District", description: "Climb 1,237 steps for stunning Buddhist views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Four Islands Longtail Tour", address: "Krabi Islands", description: "Classic Thai longtail boat hopping adventure", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Emerald Pool Natural Spa", address: "Khlong Thom District, Krabi", description: "Swim in mineral-rich natural pools", category: "Wellness", subcategory: "Hot Springs" },
    { name: "Ao Nang Walking Street", address: "Ao Nang Beach", description: "Market-style shopping near the beach", category: "Cultural", subcategory: "Local Markets" },
    { name: "Hong Islands Lagoon Kayaking", address: "Krabi Province", description: "Explore hidden lagoons and coral reefs", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Railay Viewpoint Hike", address: "Railay Beach, Krabi", description: "Short climb with sweeping coastal views", category: "Nature & Outdoors", subcategory: "Viewpoints" },
    { name: "Maya Bay Sunrise Visit", address: "Phi Phi Leh Island", description: "Famous white sand cove before the crowds", category: "Nature & Outdoors", subcategory: "Beaches" },
    { name: "Krabi Night Market", address: "Krabi Town", description: "Stalls with local snacks and souvenirs", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Bioluminescence Kayaking Tour", address: "Ao Thalane, Krabi", description: "Glow-in-the-dark plankton night paddle", category: "Cultural", subcategory: "Boat Tours" }
  ],
  "Ayutthaya" => [
    { name: "Ayutthaya Bike Tour", address: "Ayutthaya", description: "Cycle around ancient ruins and temples", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Wat Mahathat Buddha Head", address: "Ayutthaya Historical Park", description: "Iconic Buddha head nestled in tree roots", category: "Cultural", subcategory: "Monuments" },
    { name: "Bang Pa-In Palace Visit", address: "Bang Pa-In District", description: "Royal summer retreat with varied architecture", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Sunset River Cruise", address: "Ayutthaya Province", description: "Boat ride past ruins at golden hour", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Traditional Thai Massage", address: "Ayutthaya City", description: "Relax in a spa using ancient techniques", category: "Wellness", subcategory: "Spas" },
    { name: "Floating Market Food Stalls", address: "Ayutthaya Floating Market", description: "Local snacks and produce from boat vendors", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Wat Chaiwatthanaram Sunset", address: "Ayutthaya Historical Park", description: "Khmer-style temple ruins lit up at dusk", category: "Cultural", subcategory: "Monuments" },
    { name: "Elephant Kraal Pavilion", address: "Ayutthaya", description: "Historical elephant taming site", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Ayutthaya Puppet Show", address: "Ayutthaya Cultural Center", description: "Traditional Thai storytelling with marionettes", category: "Entertainment", subcategory: "Theatre" },
    { name: "Roti Sai Mai Cooking Class", address: "Ayutthaya City", description: "Learn to spin Thai cotton candy crêpes", category: "Food & Drink", subcategory: "Cooking Workshops" }
    ]
  },
  "Italy" => {
    "Rome" => [
      { name: "Colosseum Underground VIP Tour", address: "Piazza del Colosseo, Rome", description: "Arena floor access and gladiator chambers exploration",   category: "Cultural", subcategory: "Historic Sites" },
      { name: "Vatican Museums Early Access", address: "Vatican City", description: "Sistine Chapel and galleries before crowds", category: "Cultural",   subcategory: "Art Galleries" },
      { name: "Trevi Fountain Sunrise Photography", address: "Trevi District, Rome", description: "Iconic fountain without tourist masses", category:   "Cultural", subcategory: "Monuments" },
      { name: "Roman Food Tour in Trastevere", address: "Trastevere, Rome", description: "Authentic carbonara, gelato, and wine tasting", category: "Food & Drink", subcategory: "Local Cuisine" },
      { name: "Borghese Gallery Bernini Sculptures", address: "Villa Borghese, Rome", description: "World's finest baroque sculpture collection", category:   "Cultural", subcategory: "Art Galleries" },
      { name: "Roman Forum Archaeological Walk", address: "Via della Salara Vecchia, Rome", description: "Ancient Rome's political and commercial center",  category: "Cultural", subcategory: "Historic Sites" },
      { name: "Pantheon Dome Architecture Tour", address: "Piazza della Rotonda, Rome", description: "2,000-year-old concrete dome engineering marvel",   category: "Cultural", subcategory: "Architectural Sites" },
      { name: "Campo de' Fiori Market Morning", address: "Campo de' Fiori, Rome", description: "Fresh produce, flowers, and Roman breakfast", category:   "Cultural", subcategory: "Local Markets" },
      { name: "Palatine Hill Emperor's Palace", address: "Via di San Gregorio, Rome", description: "Birthplace of Rome with imperial palace ruins", category:   "Cultural", subcategory: "Historic Sites" },
      { name: "Roman Rooftop Aperitivo Experience", address: "Various locations, Rome", description: "Sunset drinks with ancient city panorama", category:  "Food & Drink", subcategory: "Cocktail Bars" }
    ],
    "Florence" => [
      { name: "Uffizi Gallery Renaissance Masterpieces", address: "Piazzale degli Uffizi, Florence", description: "Botticelli, da Vinci, and Michelangelo   collection", category: "Cultural", subcategory: "Art Galleries" },
      { name: "Duomo Cathedral Dome Climbing", address: "Piazza del Duomo, Florence", description: "436 steps to Brunelleschi's architectural triumph",   category: "Cultural", subcategory: "Architectural Sites" },
      { name: "Ponte Vecchio Jewelry Shopping", address: "Ponte Vecchio, Florence", description: "Medieval bridge lined with goldsmith workshops", category:  "Shopping", subcategory: "Independent Boutiques" },
      { name: "Accademia Gallery Michelangelo's David", address: "Via Ricasoli, Florence", description: "Original David statue and unfinished sculptures",  category: "Cultural", subcategory: "Art Galleries" },
      { name: "Tuscan Cooking Class in Chianti", address: "Chianti Region, Florence", description: "Wine estate cooking with vineyard views", category: "Food & Drink", subcategory: "Cooking Workshops" },
      { name: "Palazzo Pitti Royal Apartments", address: "Piazza de' Pitti, Florence", description: "Medici family palace with opulent rooms", category:  "Cultural", subcategory: "Historic Sites" },
      { name: "Oltrarno Artisan Workshop Tour", address: "Oltrarno District, Florence", description: "Traditional crafts: bookbinding, leather, ceramics",  category: "Cultural", subcategory: "Local Markets" },
      { name: "Piazzale Michelangelo Sunset Views", address: "Piazzale Michelangelo, Florence", description: "Panoramic Florence skyline photography spot",   category: "Nature & Outdoors", subcategory: "Viewpoints" },
      { name: "San Lorenzo Market Food Experience", address: "Piazza del Mercato Centrale, Florence", description: "Truffle hunting, wine tasting, local  delicacies", category: "Food & Drink", subcategory: "Local Cuisine" },
      { name: "Boboli Gardens Renaissance Stroll", address: "Palazzo Pitti, Florence", description: "Medici gardens with grottos and sculptures", category:   "Nature & Outdoors", subcategory: "Botanical Gardens" }
    ],
    "Venice" => [
      { name: "Doge's Palace Secret Itineraries", address: "Piazza San Marco, Venice", description: "Hidden passages, prison cells, and torture chambers",  category: "Cultural", subcategory: "Historic Sites" },
      { name: "Gondola Ride Through Hidden Canals", address: "Various canals, Venice", description: "Private waterways away from tourist routes", category:   "Cultural", subcategory: "Boat Tours" },
      { name: "Murano Glass Blowing Workshop", address: "Murano Island, Venice", description: "Traditional Venetian glass artisan techniques", category:  "Cultural", subcategory: "Local Markets" },
      { name: "St. Mark's Basilica Golden Mosaics", address: "Piazza San Marco, Venice", description: "Byzantine architecture with gold-covered interior",  category: "Cultural", subcategory: "Religious Sites" },
      { name: "Burano Island Colorful Houses Photo Walk", address: "Burano Island, Venice", description: "Rainbow-colored fishermen's houses and lace making",  category: "Cultural", subcategory: "Walking City Tours" },
      { name: "Venetian Cicchetti Bar Crawl", address: "Cannaregio District, Venice", description: "Small plates and wine in traditional bacari", category:   "Food & Drink", subcategory: "Wine Bars / Tasting" },
      { name: "Rialto Market Fresh Seafood Tour", address: "Rialto Bridge, Venice", description: "Morning fish market and canal-side breakfast", category:  "Food & Drink", subcategory: "Local Cuisine" },
      { name: "Palazzo Grassi Contemporary Art", address: "Campo San Samuele, Venice", description: "Modern art in 18th-century noble palace", category:  "Cultural", subcategory: "Art Galleries" },
      { name: "Carnival Mask Making Workshop", address: "San Polo District, Venice", description: "Traditional papier-mâché Venetian mask creation", category:  "Cultural", subcategory: "Local Markets" },
      { name: "Lido Beach Vintage Cinema Festival", address: "Lido Island, Venice", description: "Art Deco architecture and film festival atmosphere", category:  "Entertainment", subcategory: "Cinema" }
    ],
    "Milan" => [
      { name: "Duomo Cathedral Rooftop Terraces", address: "Piazza del Duomo, Milan", description: "Gothic spires and flying buttresses exploration", category:   "Cultural", subcategory: "Architectural Sites" },
      { name: "La Scala Opera House Behind Scenes", address: "Via Filodrammatici, Milan", description: "Historic theater tour and museum visit", category:  "Entertainment", subcategory: "Theatre" },
      { name: "Quadrilatero della Moda Shopping", address: "Fashion Quadrangle, Milan", description: "High-end boutiques: Prada, Versace, Armani", category:  "Shopping", subcategory: "Designer Fashion" },
      { name: "Brera District Art Gallery Hopping", address: "Brera, Milan", description: "Contemporary galleries and artistic neighborhood", category:   "Cultural", subcategory: "Art Galleries" },
      { name: "Aperitivo Hour in Navigli District", address: "Navigli, Milan", description: "Canal-side bars with complimentary buffets", category: "Food & Drink", subcategory: "Cocktail Bars" },
      { name: "The Last Supper Advance Booking", address: "Santa Maria delle Grazie, Milan", description: "da Vinci's masterpiece in original location",  category: "Cultural", subcategory: "Art Galleries" },
      { name: "San Siro Stadium Football Experience", address: "Via Piccolomini, Milan", description: "AC Milan and Inter Milan sacred ground tour", category:  "Entertainment", subcategory: "Live Music" },
      { name: "Castello Sforzesco Museum Complex", address: "Piazza Castello, Milan", description: "Medieval castle with Michelangelo's final sculpture",   category: "Cultural", subcategory: "History Museums" },
      { name: "Isola District Modern Architecture", address: "Isola, Milan", description: "Porta Nuova skyscrapers and vertical forest towers", category:   "Cultural", subcategory: "Architectural Sites" },
      { name: "Traditional Milanese Risotto Cooking", address: "Various locations, Milan", description: "Saffron risotto and cotoletta preparation class",  category: "Food & Drink", subcategory: "Cooking Workshops" }
    ],
    "Naples" => [
      { name: "Pompeii Archaeological Site Full Day", address: "Pompeii, Naples", description: "Preserved Roman city frozen by volcanic ash", category:   "Cultural", subcategory: "Historic Sites" },
      { name: "Mount Vesuvius Crater Hike", address: "Mount Vesuvius National Park", description: "Active volcano climb with Bay of Naples views", category:  "Nature & Outdoors", subcategory: "Hiking Trails" },
      { name: "Authentic Neapolitan Pizza Workshop", address: "Historic Center, Naples", description: "UNESCO-protected pizza making techniques", category:   "Food & Drink", subcategory: "Cooking Workshops" },
      { name: "Naples Underground City Tour", address: "Piazza San Gaetano, Naples", description: "Greek and Roman tunnels beneath the city", category:   "Cultural", subcategory: "Historic Sites" },
      { name: "Capri Island Blue Grotto Boat Trip", address: "Capri Island", description: "Illuminated underwater cave accessible by rowboat", category:  "Cultural", subcategory: "Boat Tours" },
      { name: "Royal Palace of Naples Throne Room", address: "Piazza del Plebiscito, Naples", description: "Bourbon dynasty opulent royal apartments", category:  "Cultural", subcategory: "Historic Sites" },
      { name: "Amalfi Coast Scenic Drive Tour", address: "Amalfi Coast", description: "Cliffside roads with Mediterranean panoramas", category: "Nature & Outdoors", subcategory: "Viewpoints" },
      { name: "San Gregorio Armeno Nativity Street", address: "Spaccanapoli, Naples", description: "Artisan workshops creating handmade cribs", category:   "Shopping", subcategory: "Independent Boutiques" },
      { name: "Castel dell'Ovo Sunset Views", address: "Via Eldorado, Naples", description: "Medieval castle on small island with harbor views", category:  "Cultural", subcategory: "Historic Sites" },
      { name: "Sfogliatelle Pastry Making Class", address: "Various locations, Naples", description: "Traditional shell-shaped pastry preparation", category:   "Food & Drink", subcategory: "Cooking Workshops" }
    ]
  },
  "France" => {
    "Paris" => [
      { name: "Eiffel Tower Summit Private Access", address: "Champ de Mars, Paris", description: "Top floor champagne experience with city panorama", category:  "Cultural", subcategory: "Monuments" },
      { name: "Louvre Museum Mona Lisa VIP Tour", address: "Rue de Rivoli, Paris", description: "Skip-the-line access to world's most famous painting",   category: "Cultural", subcategory: "Art Galleries" },
      { name: "Seine River Evening Dinner Cruise", address: "Port de Solférino, Paris", description: "Illuminated landmarks from luxury glass boat", category:  "Cultural", subcategory: "Boat Tours" },
      { name: "Montmartre Artists Quarter Walking Tour", address: "Montmartre, Paris", description: "Sacré-Cœur, street artists, and bohemian history",   category: "Cultural", subcategory: "Walking City Tours" },
      { name: "Versailles Palace and Gardens Day Trip", address: "Versailles", description: "Hall of Mirrors and Marie Antoinette's estate", category:  "Cultural", subcategory: "Architectural Sites" },
      { name: "Latin Quarter Food Market Experience", address: "5th Arrondissement, Paris", description: "Cheese, wine, and patisserie tasting tour", category:   "Food & Drink", subcategory: "Local Cuisine" },
      { name: "Arc de Triomphe Rooftop Panorama", address: "Place Charles de Gaulle, Paris", description: "Champs-Élysées views from Napoleon's monument",  category: "Cultural", subcategory: "Monuments" },
      { name: "Sainte-Chapelle Stained Glass Marvel", address: "Île de la Cité, Paris", description: "Gothic chapel with 15 towering stained glass windows",  category: "Cultural", subcategory: "Religious Sites" },
      { name: "Père Lachaise Cemetery Famous Graves", address: "20th Arrondissement, Paris", description: "Jim Morrison, Édith Piaf, and Oscar Wilde tombs",  category: "Cultural", subcategory: "Historic Sites" },
      { name: "Moulin Rouge Cabaret Show", address: "Pigalle, Paris", description: "Can-can dancers and French cabaret tradition", category: "Entertainment",   subcategory: "Theatre" }
    ],
    "Nice" => [
      { name: "Promenade des Anglais Sunset Stroll", address: "Nice Waterfront", description: "Mediterranean coastline with Belle Époque hotels", category:   "Nature & Outdoors", subcategory: "Nature Walks" },
      { name: "Monaco Monte Carlo Casino Experience", address: "Monte Carlo, Monaco", description: "Legendary gambling halls and luxury car spotting", category:  "Entertainment", subcategory: "Nightlife" },
      { name: "Château-neuf-du-Pape Wine Tasting", address: "Provence Region", description: "Premier wine region with vineyard tours", category: "Food & Drink",  subcategory: "Wine Bars / Tasting" },
      { name: "Old Town Nice Market Exploration", address: "Vieux Nice", description: "Colorful buildings, local produce, and socca pancakes", category:  "Cultural", subcategory: "Local Markets" },
      { name: "Cannes Film Festival Boulevard Walk", address: "Cannes", description: "Red carpet steps and luxury boutique shopping", category: "Entertainment",  subcategory: "Art Festivals" },
      { name: "Villa Ephrussi Rothschild Gardens", address: "Saint-Jean-Cap-Ferrat", description: "Nine themed gardens overlooking Mediterranean", category:  "Nature & Outdoors", subcategory: "Botanical Gardens" }
    ],
    "Cannes" => [
      { name: "La Croisette Seaside Promenade", address: "Boulevard de la Croisette, Cannes", description: "Luxury shopping, palm trees, and seaside views",  category: "Shopping", subcategory: "Independent Boutiques" },
      { name: "Lérins Islands Day Trip", address: "Îles de Lérins, Cannes", description: "Ferry ride to peaceful islands with monastery and fort", category:  "Nature & Outdoors", subcategory: "Nature Walks" }
    ],
    "Menton" => [
      { name: "Jardin Serre de la Madone", address: "74 Route de Gorbio, Menton", description: "Exotic botanical garden nestled in the hills", category:  "Nature & Outdoors", subcategory: "Botanical Gardens" },
      { name: "Old Town Menton Color Walk", address: "Rue Longue, Menton", description: "Photogenic pastel streets and sea views", category: "Cultural",  subcategory: "Walking City Tours" }
    ],
    "Èze" => [
      { name: "Èze Village & Exotic Garden Viewpoint", address: "Rue du Château, Èze", description: "Hilltop village with panoramic Mediterranean views",   category: "Nature & Outdoors", subcategory: "Viewpoints" }
    ]
  },
 "Spain" => {
  "Barcelona" => [
    { name: "Sagrada Familia Tower Climb", address: "Carrer de Mallorca, Barcelona", description: "Gaudí's unfinished masterpiece with spiral staircases", category: "Cultural", subcategory: "Monuments" },
    { name: "Park Güell Mosaic Terraces", address: "Carrer d'Olot, Barcelona", description: "Colorful ceramic artwork with city skyline views", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Las Ramblas Street Performance Walk", address: "Las Ramblas, Barcelona", description: "Living statues, flower markets, and street artists", category: "Entertainment", subcategory: "Street Art" },
    { name: "Gothic Quarter Medieval Maze", address: "Barri Gòtic, Barcelona", description: "13th-century streets and hidden courtyards", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Casa Batlló Dragon House Tour", address: "Passeig de Gràcia, Barcelona", description: "Gaudí's fairy-tale architecture with bone-like balconies", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Boqueria Market Tapas Crawl", address: "La Rambla, Barcelona", description: "Fresh seafood, jamón ibérico, and local delicacies", category: "Food & Drink", subcategory: "Local Cuisine" }
  ],
  "Madrid" => [
    { name: "Prado Museum Golden Triangle", address: "Calle de Ruiz de Alarcón, Madrid", description: "Velázquez, Goya, and Spanish royal collections", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Royal Palace State Rooms", address: "Calle de Bailén, Madrid", description: "3,000 rooms of Habsburg and Bourbon luxury", category: "Cultural", subcategory: "Monuments" },
    { name: "Retiro Park Crystal Palace", address: "Parque del Retiro, Madrid", description: "Victorian glass pavilion in royal gardens", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Flamenco Show in Tablao Cordobés", address: "Calle de la Paz, Madrid", description: "Authentic Spanish guitar and passionate dancing", category: "Entertainment", subcategory: "Live Music" },
    { name: "Mercado de San Miguel Gourmet Tour", address: "Plaza de San Miguel, Madrid", description: "Iron and glass market with artisan food stalls", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Gran Vía Theater District Evening", address: "Gran Vía, Madrid", description: "Spanish Broadway with neon lights and musicals", category: "Entertainment", subcategory: "Theatre" }
  ],
  "Seville" => [
    { name: "Alcázar Palace Moorish Gardens", address: "Patio de Banderas, Seville", description: "Islamic architecture with orange tree courtyards", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Cathedral Giralda Bell Tower Climb", address: "Avenida de la Constitución, Seville", description: "Gothic cathedral with Moorish minaret views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Triana Neighborhood Pottery Quarter", address: "Triana, Seville", description: "Ceramic workshops and traditional tile-making", category: "Cultural", subcategory: "Local Markets" },
    { name: "Plaza de España Andalusian Pavilion", address: "Parque de María Luisa, Seville", description: "Semi-circular palace with hand-painted tiles", category: "Cultural", subcategory: "Monuments" }
  ]
},
"Check Republic" => {
  "Prague" => [
    { name: "Prague Castle Tour", address: "Hradčany, Prague", description: "Explore the largest ancient castle complex in the world", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Charles Bridge Early Morning Walk", address: "Karlův most, Prague", description: "Stroll this iconic 14th-century bridge before the crowds", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Old Town Square Astronomical Clock Show", address: "Staroměstské náměstí, Prague", description: "Watch the hourly mechanical show of the medieval clock", category: "Cultural", subcategory: "Monuments" },
    { name: "National Gallery Prague Visit", address: "Veletržní palác, Prague", description: "Discover Czech and international art collections", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Vltava River Boat Cruise", address: "Prague Marina, Prague", description: "Relax on a scenic boat tour with city views", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Czech Beer Tasting Experience", address: "Various pubs, Prague", description: "Sample traditional Czech lagers and learn brewing history", category: "Food & Drink", subcategory: "Craft Beer" },
    { name: "Havelské tržiště Market Visit", address: "Havelské tržiště, Prague", description: "Shop local crafts and fresh produce in the historic market", category: "Cultural", subcategory: "Local Markets" },
    { name: "Prague Jazz Boat Night", address: "Vltava River, Prague", description: "Enjoy live jazz music while cruising the river", category: "Entertainment", subcategory: "Live Music" },
    { name: "Petřín Hill Hike and Observation Tower", address: "Petřín, Prague", description: "Climb the tower for panoramic city views and stroll the gardens", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Traditional Czech Cooking Workshop", address: "Cooking studio, Prague", description: "Learn to cook authentic Czech dishes with a local chef", category: "Food & Drink", subcategory: "Cooking Workshops" }
  ]
},
"Switzerland" => {
  "Spiez" => [
    { name: "Spiez Castle Museum Tour", address: "Schlossweg 9, Spiez", description: "Explore medieval castle history with lake views", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Boat Cruise on Lake Thun", address: "Spiez Marina", description: "Scenic boat ride with mountain panoramas", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Spiez Vineyard Wine Tasting", address: "Spiez Vineyards", description: "Taste local Swiss wines and enjoy vineyard views", category: "Food & Drink", subcategory: "Wine Bars / Tasting" },
    { name: "Niederhorn Hiking Trail", address: "Niederhorn near Spiez", description: "Hike with panoramic views of the Alps", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Spiez Local Market", address: "Spiez Town Center", description: "Browse fresh produce and local crafts", category: "Cultural", subcategory: "Local Markets" }
  ],

  "Zermatt" => [
    { name: "Matterhorn Glacier Paradise", address: "Zermatt", description: "Visit highest cable car station with glacier views", category: "Nature & Outdoors", subcategory: "Viewpoints" },
    { name: "Gornergrat Railway Ride", address: "Zermatt Station", description: "Mountain train ride with panoramic views", category: "Cultural", subcategory: "Bus City Tours" },
    { name: "Schwarzsee Hiking Trail", address: "Zermatt Trails", description: "Easy hike to mountain lake below the Matterhorn", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Swiss Fondue Cooking Workshop", address: "Zermatt", description: "Learn to cook traditional Swiss fondue", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Zermatt Village Walk", address: "Zermatt Town Center", description: "Walking tour of alpine village architecture", category: "Cultural", subcategory: "Walking City Tours" }
  ],

  "Lucerne" => [
    { name: "Chapel Bridge Walk", address: "Lucerne Old Town", description: "Historic wooden bridge with city views", category: "Cultural", subcategory: "Monuments" },
    { name: "Lake Lucerne Boat Cruise", address: "Lucerne Pier", description: "Boat tour with mountain scenery", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Swiss Museum of Transport", address: "Lidostrasse 5, Lucerne", description: "Exhibits on transportation and technology", category: "Cultural", subcategory: "History Museums" },
    { name: "Swiss Cheese Tasting", address: "Lucerne Market", description: "Try local cheeses and delicacies", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Mount Pilatus Hike", address: "Lucerne", description: "Hiking trail to mountain summit", category: "Nature & Outdoors", subcategory: "Hiking Trails" }
  ],

  "Bern" => [
    { name: "Zytglogge Clock Tower Tour", address: "Kramgasse 49, Bern", description: "Tour the medieval clock tower", category: "Cultural", subcategory: "Monuments" },
    { name: "Bern Historical Museum", address: "Helvetiaplatz 5, Bern", description: "History and art exhibits", category: "Cultural", subcategory: "History Museums" },
    { name: "Rosengarten Botanical Gardens", address: "Alter Aargauerstalden 31, Bern", description: "Explore rose gardens and city views", category: "Nature & Outdoors", subcategory: "Botanical Gardens" },
    { name: "Aare River Walk", address: "Aare River, Bern", description: "Scenic walk along the river", category: "Nature & Outdoors", subcategory: "Nature Walks" },
    { name: "Bern Craft Beer Tasting", address: "Local Breweries, Bern", description: "Taste local craft beers", category: "Food & Drink", subcategory: "Craft Beer" },
    { name: "Bern Old Town Market", address: "Bern Old Town", description: "Shop fresh produce and local goods", category: "Cultural", subcategory: "Local Markets" }
  ]
}
}

# === SEEDING ACTIVITIES ===
puts "Creating country-based activities..."

activity_records = []

country_activities.each do |country, cities|
  cities.each do |city, activities|
    activities.each do |activity_attrs|
      category = Category.find_by(name: activity_attrs[:category])
      unless category
        puts "⚠️  Category not found for: #{activity_attrs[:category]}"
        next
      end

      activity = Activity.create!(
        name: activity_attrs[:name],
        location: city,
        address: activity_attrs[:address],
        description: activity_attrs[:description],
        category: category,
        image_url: "https://source.unsplash.com/400x300/?#{activity_attrs[:name].parameterize}"
      )

      activity.geocode if activity.respond_to?(:geocode)

      activity_records << { country: country, activity: activity }
    end
  end
end

puts "✅ Created #{activity_records.size} activities from #{country_activities.size} countries."

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
