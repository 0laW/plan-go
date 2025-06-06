puts "🌱 Seeding..."
puts "Cleaning the DB..."

ActivityReview.destroy_all
TripActivity.destroy_all
TripUser.destroy_all
Preference.destroy_all
Friendship.destroy_all
Activity.destroy_all
Subcategory.destroy_all
Category.destroy_all
Trip.destroy_all
User.destroy_all

# Reset all PK sequences so IDs start from 1
%w[
  activity_reviews
  trip_activities
  trip_users
  preferences
  friendships
  activities
  subcategories
  categories
  trips
  users
].each do |table_name|
  ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
end

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
    email: "#{user[:first_name].downcase}@planandgo.com",
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
    { name: "Tokyo Skytree Observation Deck", address: "1-1-2 Oshiage, Sumida-ku, Tokyo 131-0045", description: "360° panoramic city views and photo opportunities", category: "Cultural", subcategory: "Viewpoints" },
    { name: "Jiro's Sushi Honten", address: "Tsukamoto Sogyo Building B1F, 4-2-15 Ginza, Chuo-ku, Tokyo", description: "World-famous sushi master experience", category: "Food & Drink", subcategory: "Michelin Star Restaurants" },
    { name: "Shibuya Sky Rooftop", address: "2-24-12 Shibuya, Shibuya City, Tokyo 150-0002", description: "Perfect aerial shots of famous crossing", category: "Cultural", subcategory: "Viewpoints" },
    { name: "Golden Gai Bar Hopping", address: "1-1-6 Kabukicho, Shinjuku City, Tokyo 160-0021", description: "Tiny themed bars in narrow alleys", category: "Food & Drink", subcategory: "Cocktail Bars" },
    { name: "TeamLab Borderless Digital Art", address: "1-3-15 Toyosu, Koto City, Tokyo 135-0061", description: "Immersive digital installations and surreal visuals", category: "Entertainment", subcategory: "Art Festivals" },
    { name: "Tsukiji Fish Market Food Tour", address: "5-2-1 Tsukiji, Chuo City, Tokyo 104-0045", description: "Tuna auction and sushi breakfast from market stalls", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Meiji Shrine Photo Walk", address: "1-1 Kamizono-cho, Shibuya City, Tokyo 151-8557", description: "Traditional shrine in forested park with photo ops", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Harajuku Street Fashion Hunt", address: "1-6 Jingumae, Shibuya City, Tokyo 150-0001", description: "Vibrant youth fashion and independent boutiques", category: "Shopping", subcategory: "Independent Boutiques" },
    { name: "Robot Restaurant Show", address: "1-7-1 Kabukicho, Shinjuku City, Tokyo 160-0021", description: "Neon, robots, and sensory overload performances", category: "Entertainment", subcategory: "Nightlife" },
    { name: "Cherry Blossom Hanami Party", address: "Ueno Park, Taito City, Tokyo 110-0007", description: "Picnic and sake under pink petals in full bloom", category: "Nature & Outdoors", subcategory: "Parks" }
  ],
  "Kyoto" => [
    { name: "Fushimi Inari Shrine Gates", address: "68 Fukakusa Yabunouchicho, Fushimi Ward, Kyoto 612-0882", description: "10,000 vermillion gates winding up mountain trails", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kikunoi Kaiseki Dinner", address: "459 Shimokawara-cho, Higashiyama Ward, Kyoto 605-0825", description: "Michelin three-star seasonal tasting journey", category: "Food & Drink", subcategory: "Michelin Star Restaurants" },
    { name: "Arashiyama Bamboo Grove", address: "Sagatenryuji Susukinobabacho, Ukyo Ward, Kyoto 616-8385", description: "Dreamlike bamboo forest perfect for morning walks", category: "Nature & Outdoors", subcategory: "Nature Walks" },
    { name: "Traditional Tea Ceremony", address: "Hanami-koji Dori, Gion District, Higashiyama Ward, Kyoto", description: "Ceremonial matcha served in tranquil teahouse", category: "Cultural", subcategory: "Local Markets" },
    { name: "Kinkaku-ji Golden Pavilion", address: "1 Kinkakujicho, Kita Ward, Kyoto 603-8361", description: "Glowing reflection shots of famous golden temple", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Pontocho Alley Dining", address: "Pontocho-dori, Nakagyo Ward, Kyoto 604-8015", description: "Historic riverside alley with terrace dining", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Kiyomizu-dera Temple Views", address: "1-294 Kiyomizu, Higashiyama Ward, Kyoto 605-0862", description: "Wooden balcony with panoramic Kyoto city views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Nishiki Market Crawl", address: "Nishikoji-dori, Nakagyo Ward, Kyoto 604-8054", description: "Tasting skewers, sweets, and street eats", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Gion Geisha Photo Tour", address: "Hanami-koji Dori, Gion District, Higashiyama Ward, Kyoto", description: "Cultural walk with glimpses of geisha in kimonos", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Philosopher's Path Cherry Walk", address: "Philosopher's Path, Sakyo Ward, Kyoto 606-8435", description: "Tranquil cherry-lined canal trail in spring", category: "Nature & Outdoors", subcategory: "Nature Walks" }
  ],
  "Osaka" => [
    { name: "Osaka Castle Spring Photos", address: "1-1 Osakajo, Chuo Ward, Osaka 540-0002", description: "Cherry blossoms surrounding iconic white castle", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Dotonbori Neon Night Walk", address: "Dotonbori, Chuo Ward, Osaka 542-0071", description: "Famous signs and bridges in nightlife epicenter", category: "Entertainment", subcategory: "Nightlife" },
    { name: "Kuromon Market Food Crawl", address: "2-4-1 Nipponbashi, Chuo Ward, Osaka 542-0073", description: "Try local seafood, wagyu skewers, and fruit mochi", category: "Food & Drink", subcategory: "Street Food" },
    { name: "Umeda Sky Building Viewpoint", address: "1-1-88 Oyodonaka, Kita Ward, Osaka 531-6023", description: "Floating observatory deck with sunset skyline", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Takoyaki Cooking Workshop", address: "3-7-5 Namba, Chuo Ward, Osaka 542-0076", description: "Make your own octopus balls with locals", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Shinsaibashi Shopping Arcade", address: "1-7-1 Shinsaibashi, Chuo Ward, Osaka 542-0085", description: "Boutiques, fashion chains, and café stops", category: "Shopping", subcategory: "Independent Boutiques" },
    { name: "Sumiyoshi Taisha Morning Visit", address: "2-9-89 Sumiyoshi, Sumiyoshi Ward, Osaka 558-0045", description: "Oldest Shinto shrine with arched bridge photo op", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Spa World Onsen Day", address: "3-4-24 Ebisuhigashi, Naniwa Ward, Osaka 556-0002", description: "Theme-park-style hot springs from around the globe", category: "Wellness", subcategory: "Hot Springs" },
    { name: "Hozenji Yokocho Hidden Alley", address: "1-2-16 Namba, Chuo Ward, Osaka 542-0076", description: "Candle-lit alley with mossy statue and yakitori", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Osaka Bay Evening Cruise", address: "1-5-10 Kaigandori, Minato Ward, Osaka 552-0022", description: "Lit-up cityscape from ferry deck at night", category: "Entertainment", subcategory: "Boat Tours" }
  ],
  "Hiroshima" => [
    { name: "Peace Memorial Photo Stop", address: "1-10 Nakajima-cho, Naka Ward, Hiroshima 730-0811", description: "Symbolic A-Bomb Dome and eternal flame", category: "Cultural", subcategory: "Monuments" },
    { name: "Miyajima Floating Torii Shot", address: "1-1 Miyajimacho, Hatsukaichi, Hiroshima 739-0588", description: "Red gate standing in sea at high tide", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Hiroshima-style Okonomiyaki Class", address: "5-13 Shintenchi, Naka Ward, Hiroshima 730-0034", description: "Learn to layer pancake and toppings", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Miyajima Deer Park", address: "Miyajimacho, Hatsukaichi, Hiroshima 739-0588", description: "Freely roaming sacred deer near shrine", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Hiroshima Castle at Night", address: "21-1 Motomachi, Naka Ward, Hiroshima 730-0011", description: "Illuminated replica castle and moat", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Shukkeien Garden Tea Stop", address: "2-11 Kaminobori-cho, Naka Ward, Hiroshima 730-0014", description: "Miniature landscape garden with tea pavilions", category: "Wellness", subcategory: "Meditation Centers" },
    { name: "Mazda Factory Tour", address: "3-1 Shinchi, Fuchu-cho, Aki District, Hiroshima 735-8670", description: "Inside look at Japanese car production", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Mitaki-dera Forest Trail", address: "411 Mitakiyama, Nishi Ward, Hiroshima 733-0805", description: "Hike through waterfalls to hidden mountain temple", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Island Boat Excursion", address: "Ujina Kaigan, Minami Ward, Hiroshima 734-0011", description: "Visit lesser-known islands on scenic ferry loop", category: "Nature & Outdoors", subcategory: "Boat Tours" },
    { name: "Okonomimura Food Hall", address: "5-13 Shintenchi, Naka Ward, Hiroshima 730-0034", description: "Four floors of sizzling okonomiyaki booths", category: "Food & Drink", subcategory: "Local Cuisine" }
  ],
  "Nara" => [
    { name: "Todai-ji Daibutsu Visit", address: "406-1 Zoshicho, Nara 630-8587", description: "See the Great Buddha in wooden temple hall", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Deer Selfie Time", address: "Nara Park, 469 Zoshicho, Nara 630-8501", description: "Pose with the sacred deer of Nara Park", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Kasuga Taisha Lantern Path", address: "160 Kasuganocho, Nara 630-8212", description: "Stone and bronze lanterns lit in magical glow", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kofuku-ji Pagoda Photos", address: "48 Noboriojicho, Nara 630-8213", description: "Five-story wooden pagoda from 8th century", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Kaiseki at Mahoroba", address: "254-1 Takabatakecho, Nara 630-8301", description: "Elegant seasonal tasting menu with local ingredients", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Sake Brewery Crawl", address: "Naramachi District, Nara 630-8333", description: "Historic district with traditional sake tastings", category: "Food & Drink", subcategory: "Wine Bars / Tasting" },
    { name: "Isuien Garden Walk", address: "74 Suimoncho, Nara 630-8208", description: "Seasons and borrowed scenery in peaceful garden", category: "Nature & Outdoors", subcategory: "Botanical Gardens" },
    { name: "Mount Wakakusa Hike", address: "Wakakusayama, Zoshicho, Nara 630-8211", description: "Gentle climb for panoramic city and forest views", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Buddhist Art Museum Visit", address: "50 Noboriojicho, Nara 630-8213", description: "Rare relics and sculpture exhibitions", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Yoshikien Garden Tour", address: "60-1 Hanashiba-cho, Nara 630-8336", description: "Photography-friendly gardens with changing colors", category: "Cultural", subcategory: "Walking City Tours" }
    ]
  },
"Thailand" => {
  "Bangkok" => [
    {
      name: "Grand Palace Golden Spires",
      address: "Na Phra Lan Rd, Phra Nakhon, Bangkok 10200, Thailand",
      description: "Intricate Thai architecture perfect for detail shots",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Gaggan Progressive Indian Cuisine",
      address: "68 Sukhumvit 31, Khlong Tan Nuea, Watthana, Bangkok 10110, Thailand",
      description: "One of Asia’s top restaurants for molecular Indian dishes",
      category: "Food & Drink",
      subcategory: "Michelin Star Restaurants"
    },
    {
      name: "Wat Arun Temple Climb",
      address: "158 Thanon Wang Doem, Wat Arun, Bangkok Yai, Bangkok 10600, Thailand",
      description: "The Temple of Dawn offering panoramic city and river views",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Chatuchak Market Treasure Hunt",
      address: "587/10 Kamphaeng Phet 2 Rd, Chatuchak, Bangkok 10900, Thailand",
      description: "Thousands of stalls offering crafts, vintage finds, and street snacks",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Khao San Road Food Crawl",
      address: "Khao San Rd, Talat Yot, Phra Nakhon, Bangkok 10200, Thailand",
      description: "Bustling backpacker strip famous for street eats",
      category: "Food & Drink",
      subcategory: "Street Food"
    },
    {
      name: "Jim Thompson House Museum",
      address: "6 Soi Kasemsan 2, Rama 1 Rd, Pathum Wan, Bangkok 10330, Thailand",
      description: "Historic home of silk entrepreneur showcasing Southeast Asian art",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Chao Phraya River Cruise",
      address: "River City Bangkok, 23 Si Phraya Pier, Yota Rd, Sampantawong, Bangkok 10100, Thailand",
      description: "Evening boat ride past illuminated temples and palaces",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Lumpini Park Tai Chi Session",
      address: "Rama IV Rd, Lumphini, Pathum Wan, Bangkok 10330, Thailand",
      description: "Join locals for morning movement and calm in nature",
      category: "Wellness",
      subcategory: "Meditation Centers"
    },
    {
      name: "Bangkok Thai Cooking Class",
      address: "153/3 Soi Sukhumvit 63, Khlong Tan Nuea, Watthana, Bangkok 10110, Thailand",
      description: "Market shopping and hands-on cooking of Thai classics",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    },
    {
      name: "Sky Bar at Lebua State Tower",
      address: "1055 Silom Rd, Silom, Bang Rak, Bangkok 10500, Thailand",
      description: "Sky-high cocktails and skyline views from a world-famous bar",
      category: "Food & Drink",
      subcategory: "Cocktail Bars"
    }
  ],
  "Chiang Mai" => [
    {
      name: "Doi Suthep Temple Visit",
      address: "Huai Kaew Rd, Tambon Suthep, Amphoe Mueang Chiang Mai, Chiang Mai 50200, Thailand",
      description: "Golden mountaintop temple overlooking Chiang Mai",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Chiang Mai Night Bazaar",
      address: "41 Chang Khlan Rd, Tambon Chang Khlan, Amphoe Mueang Chiang Mai, Chiang Mai 50100, Thailand",
      description: "Handmade crafts, silver jewelry, and food stalls",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Elephant Nature Park Visit",
      address: "1 Ratmakka Rd, Phra Sing, Chiang Mai 50200, Thailand",
      description: "Rescue center focused on ethical elephant care",
      category: "Nature & Outdoors",
      subcategory: "Nature Walks"
    },
    {
      name: "Old City Temple Walking Tour",
      address: "Chiang Mai Old City, Amphoe Mueang Chiang Mai, Chiang Mai 50000, Thailand",
      description: "Explore ancient temples on foot inside old city walls",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Sunday Walking Street Market",
      address: "Ratchadamnoen Rd, Phra Sing, Mueang Chiang Mai District, Chiang Mai 50200, Thailand",
      description: "Arts, crafts, and street performances",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Doi Inthanon National Park Hike",
      address: "Chom Thong District, Chiang Mai 50160, Thailand",
      description: "Waterfalls and viewpoints in Thailand's highest peak",
      category: "Nature & Outdoors",
      subcategory: "Viewpoints"
    },
    {
      name: "Khantoke Dinner & Dance Show",
      address: "Various venues, Chiang Mai, Thailand",
      description: "Northern Thai cuisine paired with cultural dance",
      category: "Entertainment",
      subcategory: "Art Festivals"
    },
    {
      name: "Sticky Waterfall Hike",
      address: "Mae Taeng District, Chiang Mai 50150, Thailand",
      description: "Unique climbable limestone waterfall",
      category: "Nature & Outdoors",
      subcategory: "Hiking Trails"
    },
    {
      name: "Hill Tribe Homestay Experience",
      address: "Various locations, Chiang Mai, Thailand",
      description: "Cultural immersion with local hill tribes",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Zoe in Yellow Bar Crawl",
      address: "Nimmanhaemin Rd, Suthep, Mueang Chiang Mai District, Chiang Mai 50200, Thailand",
      description: "Chiang Mai’s liveliest nightlife hub",
      category: "Entertainment",
      subcategory: "Nightlife"
    }
  ],
  "Phuket" => [
    {
      name: "Patong Beach Sunset Walk",
      address: "Phra-Phuket-Kaew Rd, Kathu, Phuket 83150, Thailand",
      description: "Golden hour on Phuket’s busiest beach",
      category: "Nature & Outdoors",
      subcategory: "Beaches"
    },
    {
      name: "Mom Tri's Boathouse",
      address: "30 Kata Noi Rd, Karon, Mueang Phuket District, Phuket 83100, Thailand",
      description: "Elegant beachfront fine dining",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Big Buddha Viewpoint",
      address: "Soi Yot Sane 1, Karon, Mueang Phuket District, Phuket 83100, Thailand",
      description: "Giant hilltop statue with panoramic views",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Phi Phi Islands Boat Trip",
      address: "Departure from Phuket Island; day trip to Phi Phi Islands, Thailand",
      description: "Day trip with snorkeling and limestone cliffs",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Phuket Old Town Photo Walk",
      address: "Mueang Phuket District, Phuket 83000, Thailand",
      description: "Colorful Sino‑Portuguese shophouses and murals",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Phuket FantaSea Show",
      address: "99 Kamala Beach, Kamala, Kathu, Phuket 83150, Thailand",
      description: "Large‑scale Thai culture‑themed performance",
      category: "Entertainment",
      subcategory: "Theatre"
    },
    {
      name: "Kata Beach Surfing Session",
      address: "Kata Beach, Karon, Mueang Phuket District, Phuket 83100, Thailand",
      description: "Surf‑friendly beach for beginners",
      category: "Nature & Outdoors",
      subcategory: "Beaches"
    },
    {
      name: "Bangla Road Night Out",
      address: "Bangla Rd, Kathu, Phuket 83150, Thailand",
      description: "Loud nightlife scene with bars and neon chaos",
      category: "Entertainment",
      subcategory: "Nightlife"
    },
    {
      name: "James Bond Island Kayak Tour",
      address: "Phang Nga Bay, Phang Nga Province, Thailand",
      description: "Paddle through sea caves and limestone towers",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Blue Elephant Cooking School",
      address: "96 Krabi Rd, Talat Nuea, Mueang Phuket District, Phuket 83000, Thailand",
      description: "Gourmet cooking class in historic setting",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    }
  ],
  "Krabi" => [
    {
      name: "Railay Beach Climbing",
      address: "Railay Peninsula, Mueang Krabi District, Krabi 81000, Thailand",
      description: "Climb dramatic limestone cliffs by the sea",
      category: "Nature & Outdoors",
      subcategory: "Hiking Trails"
    },
    {
      name: "Tiger Cave Temple Hike",
      address: "35 Tambon Krabi Noi, Amphoe Mueang Krabi, Krabi 81000, Thailand",
      description: "Climb 1,237 steps for stunning Buddhist views",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Four Islands Longtail Tour",
      address: "Departure from Ao Nang, Krabi Province, Thailand",
      description: "Classic Thai longtail boat hopping adventure",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Emerald Pool Natural Spa",
      address: "Khlong Thom Nuea, Khlong Thom District, Krabi 81120, Thailand",
      description: "Swim in mineral‑rich natural pools",
      category: "Wellness",
      subcategory: "Hot Springs"
    },
    {
      name: "Ao Nang Walking Street",
      address: "Ao Nang Beach, Mueang Krabi District, Krabi 81000, Thailand",
      description: "Market‑style shopping near the beach",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Hong Islands Lagoon Kayaking",
      address: "Krabi Province, Thailand",
      description: "Explore hidden lagoons and coral reefs",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Railay Viewpoint Hike",
      address: "Railay Beach, Mueang Krabi District, Krabi 81000, Thailand",
      description: "Short climb with sweeping coastal views",
      category: "Nature & Outdoors",
      subcategory: "Viewpoints"
    },
    {
      name: "Maya Bay Sunrise Visit",
      address: "Phi Phi Leh Island, Krabi Province, Thailand",
      description: "Famous white sand cove before the crowds",
      category: "Nature & Outdoors",
      subcategory: "Beaches"
    },
    {
      name: "Krabi Night Market",
      address: "Krabi Town, Mueang Krabi District, Krabi 81000, Thailand",
      description: "Stalls with local snacks and souvenirs",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Bioluminescence Kayaking Tour",
      address: "Ao Thalane, Krabi Province, Thailand",
      description: "Glow‑in‑the‑dark plankton night paddle",
      category: "Cultural",
      subcategory: "Boat Tours"
    }
  ],
  "Ayutthaya" => [
    {
      name: "Ayutthaya Bike Tour",
      address: "Ayutthaya Historical Park, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Cycle around ancient ruins and temples",
      category: "Cultural",
      subcategory: "Walking City Tours"
    },
    {
      name: "Wat Mahathat Buddha Head",
      address: "Ayutthaya Historical Park, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Iconic Buddha head nestled in tree roots",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Bang Pa‑In Palace Visit",
      address: "Bang Pa‑In District, Phra Nakhon Si Ayutthaya 13160, Thailand",
      description: "Royal summer retreat with varied architecture",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Sunset River Cruise",
      address: "Chao Phraya River, Ayutthaya 13000, Thailand",
      description: "Boat ride past ruins at golden hour",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Traditional Thai Massage",
      address: "Ayutthaya City, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Relax in a spa using ancient techniques",
      category: "Wellness",
      subcategory: "Spas"
    },
    {
      name: "Floating Market Food Stalls",
      address: "Ayothaya Floating Market, Bang Pa‑In District, Phra Nakhon Si Ayutthaya 13160, Thailand",
      description: "Local snacks and produce from boat vendors",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Wat Chaiwatthanaram Sunset",
      address: "Wat Chaiwatthanaram, Pratu Chai, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Khmer‑style temple ruins lit up at dusk",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Elephant Kraal Pavilion",
      address: "Ayutthaya Historical Park, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Historical elephant taming site",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Ayutthaya Puppet Show",
      address: "Ayutthaya Cultural Center, Pratuchai, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Traditional Thai storytelling with marionettes",
      category: "Entertainment",
      subcategory: "Theatre"
    },
    {
      name: "Roti Sai Mai Cooking Class",
      address: "Ayutthaya City, Phra Nakhon Si Ayutthaya 13000, Thailand",
      description: "Learn to spin Thai cotton candy crêpes",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    }
  ]
},
"Italy" => {
  "Rome" => [
    {
      name: "Colosseum Underground VIP Tour",
      address: "Piazza del Colosseo, 1, 00184 Roma RM, Italy",
      description: "Arena floor access and gladiator chambers exploration",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Vatican Museums Early Access",
      address: "Viale Vaticano, 00120 Città del Vaticano, Vatican City",
      description: "Sistine Chapel and galleries before crowds",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Trevi Fountain Sunrise Photography",
      address: "Piazza di Trevi, 00187 Roma RM, Italy",
      description: "Iconic fountain without tourist masses",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Roman Food Tour in Trastevere",
      address: "Piazza Trilussa 46, 00153 Roma RM, Italy",
      description: "Authentic carbonara, gelato, and wine tasting",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Borghese Gallery Bernini Sculptures",
      address: "Piazzale Scipione Borghese, 5, 00197 Roma RM, Italy",
      description: "World's finest baroque sculpture collection",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Roman Forum Archaeological Walk",
      address: "Via della Salara Vecchia, 5/6, 00186 Roma RM, Italy",
      description: "Ancient Rome's political and commercial center",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Pantheon Dome Architecture Tour",
      address: "Piazza della Rotonda, 00186 Roma RM, Italy",
      description: "2,000-year-old concrete dome engineering marvel",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Campo de' Fiori Market Morning",
      address: "Piazza Campo de' Fiori, 00186 Roma RM, Italy",
      description: "Fresh produce, flowers, and Roman breakfast",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Palatine Hill Emperor's Palace",
      address: "Via di San Gregorio, 30, 00186 Roma RM, Italy",
      description: "Birthplace of Rome with imperial palace ruins",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Roman Rooftop Aperitivo Experience",
      address: "Various rooftop bars, central Rome, Italy",
      description: "Sunset drinks with ancient city panorama",
      category: "Food & Drink",
      subcategory: "Cocktail Bars"
    }
  ],
  "Florence" => [
    {
      name: "Uffizi Gallery Renaissance Masterpieces",
      address: "Piazzale degli Uffizi, 6, 50122 Firenze FI, Italy",
      description: "Botticelli, da Vinci, and Michelangelo collection",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Duomo Cathedral Dome Climbing",
      address: "Piazza del Duomo, 50122 Firenze FI, Italy",
      description: "436 steps to Brunelleschi's architectural triumph",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Ponte Vecchio Jewelry Shopping",
      address: "Ponte Vecchio, 50125 Firenze FI, Italy",
      description: "Medieval bridge lined with goldsmith workshops",
      category: "Shopping",
      subcategory: "Independent Boutiques"
    },
    {
      name: "Accademia Gallery Michelangelo's David",
      address: "Via Ricasoli, 60, 50122 Firenze FI, Italy",
      description: "Original David statue and unfinished sculptures",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Tuscan Cooking Class in Chianti",
      address: "Chianti region, near Florence, Tuscany, Italy",
      description: "Wine estate cooking with vineyard views",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    },
    {
      name: "Palazzo Pitti Royal Apartments",
      address: "Piazza de' Pitti, 1, 50125 Firenze FI, Italy",
      description: "Medici family palace with opulent rooms",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Oltrarno Artisan Workshop Tour",
      address: "Oltrarno District, 50125 Firenze FI, Italy",
      description: "Traditional crafts: bookbinding, leather, ceramics",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Piazzale Michelangelo Sunset Views",
      address: "Piazzale Michelangelo, 50125 Firenze FI, Italy",
      description: "Panoramic Florence skyline photography spot",
      category: "Nature & Outdoors",
      subcategory: "Viewpoints"
    },
    {
      name: "San Lorenzo Market Food Experience",
      address: "Piazza del Mercato Centrale, 50123 Firenze FI, Italy",
      description: "Truffle hunting, wine tasting, local delicacies",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Boboli Gardens Renaissance Stroll",
      address: "Palazzo Pitti, 1, 50125 Firenze FI, Italy",
      description: "Medici gardens with grottos and sculptures",
      category: "Nature & Outdoors",
      subcategory: "Botanical Gardens"
    }
  ],
  "Venice" => [
    {
      name: "Doge's Palace Secret Itineraries",
      address: "Piazza San Marco, 1, 30124 Venezia VE, Italy",
      description: "Hidden passages, prison cells, and torture chambers",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Gondola Ride Through Hidden Canals",
      address: "Various canals, central Venice, Italy",
      description: "Private waterways away from tourist routes",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Murano Glass Blowing Workshop",
      address: "Murano Island, 30141 Venezia VE, Italy",
      description: "Traditional Venetian glass artisan techniques",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "St. Mark's Basilica Golden Mosaics",
      address: "Piazza San Marco, 328, 30124 Venezia VE, Italy",
      description: "Byzantine architecture with gold-covered interior",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Burano Island Colorful Houses Photo Walk",
      address: "Burano Island, 30142 Venezia VE, Italy",
      description: "Rainbow-colored fishermen's houses and lace making",
      category: "Cultural",
      subcategory: "Walking City Tours"
    },
    {
      name: "Venetian Cicchetti Bar Crawl",
      address: "Cannaregio District, Venice, 30121 Venezia VE, Italy",
      description: "Small plates and wine in traditional bacari",
      category: "Food & Drink",
      subcategory: "Wine Bars / Tasting"
    },
    {
      name: "Rialto Market Fresh Seafood Tour",
      address: "Rialto Bridge, 30125 Venezia VE, Italy",
      description: "Morning fish market and canal-side breakfast",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Palazzo Grassi Contemporary Art",
      address: "Campo San Samuele, 3231, 30124 Venezia VE, Italy",
      description: "Modern art in 18th-century noble palace",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Carnival Mask Making Workshop",
      address: "San Polo District, 30125 Venezia VE, Italy",
      description: "Traditional papier-mâché Venetian mask creation",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Lido Beach Vintage Cinema Festival",
      address: "Lido Island, 30126 Venezia VE, Italy",
      description: "Art Deco architecture and film festival atmosphere",
      category: "Entertainment",
      subcategory: "Cinema"
    }
  ],
  "Milan" => [
    {
      name: "Duomo Cathedral Rooftop Terraces",
      address: "Piazza del Duomo, 20122 Milano MI, Italy",
      description: "Gothic spires and flying buttresses exploration",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "La Scala Opera House Behind Scenes",
      address: "Via Filodrammatici, 2, 20121 Milano MI, Italy",
      description: "Historic theater tour and museum visit",
      category: "Entertainment",
      subcategory: "Theatre"
    },
    {
      name: "Quadrilatero della Moda Shopping",
      address: "Via Montenapoleone, Milan Fashion Quadrangle, Milano MI, Italy",
      description: "High-end boutiques: Prada, Versace, Armani",
      category: "Shopping",
      subcategory: "Designer Fashion"
    },
    {
      name: "Brera District Art Gallery Hopping",
      address: "Brera District, 20121 Milano MI, Italy",
      description: "Contemporary galleries and artistic neighborhood",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Aperitivo Hour in Navigli District",
      address: "Navigli District, 20143 Milano MI, Italy",
      description: "Canal-side bars with complimentary buffets",
      category: "Food & Drink",
      subcategory: "Cocktail Bars"
    },
    {
      name: "The Last Supper Advance Booking",
      address: "Piazza di Santa Maria delle Grazie, 20123 Milano MI, Italy",
      description: "da Vinci's masterpiece in original location",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "San Siro Stadium Football Experience",
      address: "Via Piccolomini, 5, 20151 Milano MI, Italy",
      description: "AC Milan and Inter Milan sacred ground tour",
      category: "Entertainment",
      subcategory: "Live Music"
    },
    {
      name: "Castello Sforzesco Museum Complex",
      address: "Piazza Castello, 20121 Milano MI, Italy",
      description: "Medieval castle with Michelangelo's final sculpture",
      category: "Cultural",
      subcategory: "History Museums"
    },
    {
      name: "Isola District Modern Architecture",
      address: "Isola District, 20159 Milano MI, Italy",
      description: "Porta Nuova skyscrapers and vertical forest towers",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Traditional Milanese Risotto Cooking",
      address: "Various cooking schools, central Milan, Italy",
      description: "Saffron risotto and cotoletta preparation class",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    }
  ],
  "Naples" => [
    {
      name: "Pompeii Archaeological Site Full Day",
      address: "Via Villa dei Misteri, Pompeii, 80045 Napoli NA, Italy",
      description: "Preserved Roman city frozen by volcanic ash",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Mount Vesuvius Crater Hike",
      address: "Mount Vesuvius National Park, 80046 Vesuvius, Napoli NA, Italy",
      description: "Active volcano climb with Bay of Naples views",
      category: "Nature & Outdoors",
      subcategory: "Hiking Trails"
    },
    {
      name: "Authentic Neapolitan Pizza Workshop",
      address: "Historic Center, 80138 Napoli NA, Italy",
      description: "UNESCO‑protected pizza making techniques",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    },
    {
      name: "Naples Underground City Tour",
      address: "Piazza San Gaetano, 80138 Napoli NA, Italy",
      description: "Greek and Roman tunnels beneath the city",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Capri Island Blue Grotto Boat Trip",
      address: "Departure from Naples; boat to Capri Island, Italy",
      description: "Illuminated underwater cave accessible by rowboat",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Royal Palace of Naples Throne Room",
      address: "Piazza del Plebiscito, 1, 80132 Napoli NA, Italy",
      description: "Bourbon dynasty opulent royal apartments",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Amalfi Coast Scenic Drive Tour",
      address: "Amalfi Coast, Campania, Italy",
      description: "Cliffside roads with Mediterranean panoramas",
      category: "Nature & Outdoors",
      subcategory: "Viewpoints"
    },
    {
      name: "San Gregorio Armeno Nativity Street",
      address: "Spaccanapoli, 80138 Napoli NA, Italy",
      description: "Artisan workshops creating handmade cribs",
      category: "Shopping",
      subcategory: "Independent Boutiques"
    },
    {
      name: "Castel dell'Ovo Sunset Views",
      address: "Via Eldorado, 3, 80132 Napoli NA, Italy",
      description: "Medieval castle on small island with harbor views",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Sfogliatelle Pastry Making Class",
      address: "Various cooking studios, Naples, Italy",
      description: "Traditional shell-shaped pastry preparation",
      category: "Food & Drink",
      subcategory: "Cooking Workshops"
    }
  ]
},
  "France" => {
  "Paris" => [
    {
      name: "Eiffel Tower Summit Private Access",
      address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France",
      description: "Top floor champagne experience with city panorama",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Louvre Museum Mona Lisa VIP Tour",
      address: "Rue de Rivoli, 75001 Paris, France",
      description: "Skip-the-line access to world's most famous painting",
      category: "Cultural",
      subcategory: "Art Galleries"
    },
    {
      name: "Seine River Evening Dinner Cruise",
      address: "Port de Solférino, 75007 Paris, France",
      description: "Illuminated landmarks from luxury glass boat",
      category: "Cultural",
      subcategory: "Boat Tours"
    },
    {
      name: "Montmartre Artists Quarter Walking Tour",
      address: "Place du Tertre, 75018 Paris, France",
      description: "Sacré-Cœur, street artists, and bohemian history",
      category: "Cultural",
      subcategory: "Walking City Tours"
    },
    {
      name: "Versailles Palace and Gardens Day Trip",
      address: "Place d'Armes, 78000 Versailles, France",
      description: "Hall of Mirrors and Marie Antoinette's estate",
      category: "Cultural",
      subcategory: "Architectural Sites"
    },
    {
      name: "Latin Quarter Food Market Experience",
      address: "Rue Mouffetard, 75005 Paris, France",
      description: "Cheese, wine, and patisserie tasting tour",
      category: "Food & Drink",
      subcategory: "Local Cuisine"
    },
    {
      name: "Arc de Triomphe Rooftop Panorama",
      address: "Place Charles de Gaulle, 75008 Paris, France",
      description: "Champs-Élysées views from Napoleon's monument",
      category: "Cultural",
      subcategory: "Monuments"
    },
    {
      name: "Sainte-Chapelle Stained Glass Marvel",
      address: "8 Boulevard du Palais, 75001 Paris, France",
      description: "Gothic chapel with 15 towering stained glass windows",
      category: "Cultural",
      subcategory: "Religious Sites"
    },
    {
      name: "Père Lachaise Cemetery Famous Graves",
      address: "16 Rue du Repos, 75020 Paris, France",
      description: "Jim Morrison, Édith Piaf, and Oscar Wilde tombs",
      category: "Cultural",
      subcategory: "Historic Sites"
    },
    {
      name: "Moulin Rouge Cabaret Show",
      address: "82 Boulevard de Clichy, 75018 Paris, France",
      description: "Can-can dancers and French cabaret tradition",
      category: "Entertainment",
      subcategory: "Theatre"
    }
  ],
  "Nice" => [
    {
      name: "Promenade des Anglais Sunset Stroll",
      address: "Promenade des Anglais, 06000 Nice, France",
      description: "Mediterranean coastline with Belle Époque hotels",
      category: "Nature & Outdoors",
      subcategory: "Nature Walks"
    },
    {
      name: "Monaco Monte Carlo Casino Experience",
      address: "Place du Casino, 98000 Monaco",
      description: "Legendary gambling halls and luxury car spotting",
      category: "Entertainment",
      subcategory: "Nightlife"
    },
    {
      name: "Châteauneuf-du-Pape Wine Tasting",
      address: "Châteauneuf-du-Pape, 84230 Provence-Alpes-Côte d'Azur, France",
      description: "Premier wine region with vineyard tours",
      category: "Food & Drink",
      subcategory: "Wine Bars / Tasting"
    },
    {
      name: "Old Town Nice Market Exploration",
      address: "Cours Saleya, 06300 Nice, France",
      description: "Colorful buildings, local produce, and socca pancakes",
      category: "Cultural",
      subcategory: "Local Markets"
    },
    {
      name: "Cannes Film Festival Boulevard Walk",
      address: "Boulevard de la Croisette, 06400 Cannes, France",
      description: "Red carpet steps and luxury boutique shopping",
      category: "Entertainment",
      subcategory: "Art Festivals"
    },
    {
      name: "Villa Ephrussi Rothschild Gardens",
      address: "1 Avenue Ephrussi de Rothschild, 06230 Saint-Jean-Cap-Ferrat, France",
      description: "Nine themed gardens overlooking Mediterranean",
      category: "Nature & Outdoors",
      subcategory: "Botanical Gardens"
    }
  ],
  "Cannes" => [
    {
      name: "La Croisette Seaside Promenade",
      address: "Boulevard de la Croisette, 06400 Cannes, France",
      description: "Luxury shopping, palm trees, and seaside views",
      category: "Shopping",
      subcategory: "Independent Boutiques"
    },
    {
      name: "Lérins Islands Day Trip",
      address: "Port de Cannes, 06400 Cannes, France",
      description: "Ferry ride to peaceful islands with monastery and fort",
      category: "Nature & Outdoors",
      subcategory: "Nature Walks"
    }
  ],
  "Menton" => [
    {
      name: "Jardin Serre de la Madone",
      address: "74 Route de Gorbio, 06500 Menton, France",
      description: "Exotic botanical garden nestled in the hills",
      category: "Nature & Outdoors",
      subcategory: "Botanical Gardens"
    },
    {
      name: "Old Town Menton Color Walk",
      address: "Rue Longue, 06500 Menton, France",
      description: "Photogenic pastel streets and sea views",
      category: "Cultural",
      subcategory: "Walking City Tours"
    }
  ],
  "Èze" => [
    {
      name: "Èze Village & Exotic Garden Viewpoint",
      address: "Rue du Château, 06360 Èze, France",
      description: "Hilltop village with panoramic Mediterranean views",
      category: "Nature & Outdoors",
      subcategory: "Viewpoints"
    }
  ]
},
"Spain" => {
  "Barcelona" => [
    { name: "Sagrada Familia Tower Climb", address: "Carrer de Mallorca, 401, 08013 Barcelona", description: "Gaudí's unfinished masterpiece with spiral staircases", category: "Cultural", subcategory: "Monuments" },
    { name: "Park Güell Mosaic Terraces", address: "Carrer d'Olot, 5, 08024 Barcelona", description: "Colorful ceramic artwork with city skyline views", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Las Ramblas Street Performance Walk", address: "La Rambla, 08002 Barcelona", description: "Living statues, flower markets, and street artists", category: "Entertainment", subcategory: "Street Art" },
    { name: "Gothic Quarter Medieval Maze", address: "Barri Gòtic, 08002 Barcelona", description: "13th-century streets and hidden courtyards", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Casa Batlló Dragon House Tour", address: "Passeig de Gràcia, 43, 08007 Barcelona", description: "Gaudí's fairy-tale architecture with bone-like balconies", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Boqueria Market Tapas Crawl", address: "La Rambla, 91, 08001 Barcelona", description: "Fresh seafood, jamón ibérico, and local delicacies", category: "Food & Drink", subcategory: "Local Cuisine" }
  ],
  "Madrid" => [
    { name: "Prado Museum Golden Triangle", address: "Calle de Ruiz de Alarcón, 23, 28014 Madrid", description: "Velázquez, Goya, and Spanish royal collections", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Royal Palace State Rooms", address: "Calle de Bailén, s/n, 28071 Madrid", description: "3,000 rooms of Habsburg and Bourbon luxury", category: "Cultural", subcategory: "Monuments" },
    { name: "Retiro Park Crystal Palace", address: "Plaza de la Independencia, 7, 28001 Madrid", description: "Victorian glass pavilion in royal gardens", category: "Nature & Outdoors", subcategory: "Parks" },
    { name: "Flamenco Show in Tablao Cordobés", address: "Calle de la Cruz, 14, 28012 Madrid", description: "Authentic Spanish guitar and passionate dancing", category: "Entertainment", subcategory: "Live Music" },
    { name: "Mercado de San Miguel Gourmet Tour", address: "Plaza de San Miguel, s/n, 28005 Madrid", description: "Iron and glass market with artisan food stalls", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Gran Vía Theater District Evening", address: "Gran Vía, 28013 Madrid", description: "Spanish Broadway with neon lights and musicals", category: "Entertainment", subcategory: "Theatre" }
  ],
  "Seville" => [
    { name: "Alcázar Palace Moorish Gardens", address: "Patio de Banderas, s/n, 41004 Sevilla", description: "Islamic architecture with orange tree courtyards", category: "Cultural", subcategory: "Architectural Sites" },
    { name: "Cathedral Giralda Bell Tower Climb", address: "Avenida de la Constitución, s/n, 41004 Sevilla", description: "Gothic cathedral with Moorish minaret views", category: "Cultural", subcategory: "Religious Sites" },
    { name: "Triana Neighborhood Pottery Quarter", address: "Calle San Jacinto, 41010 Sevilla", description: "Ceramic workshops and traditional tile-making", category: "Cultural", subcategory: "Local Markets" },
    { name: "Plaza de España Andalusian Pavilion", address: "Parque de María Luisa, s/n, 41013 Sevilla", description: "Semi-circular palace with hand-painted tiles", category: "Cultural", subcategory: "Monuments" }
  ]
},
"Check Republic" => {
  "Prague" => [
    { name: "Charles Bridge Early Morning Walk", address: "Karlův most, 110 00 Prague 1", description: "Stroll this iconic 14th-century bridge before the crowds", category: "Cultural", subcategory: "Walking City Tours" },
    { name: "Old Town Square Astronomical Clock Show", address: "Staroměstské náměstí 1, 110 00 Prague 1", description: "Watch the hourly mechanical show of the medieval clock", category: "Cultural", subcategory: "Monuments" },
    { name: "National Gallery Prague Visit", address: "Veletržní palác, Dukelských hrdinů 47, 170 00 Prague 7", description: "Discover Czech and international art collections", category: "Cultural", subcategory: "Art Galleries" },
    { name: "Vltava River Boat Cruise", address: "Čechův most, 110 00 Prague 1 (Boat Docks)", description: "Relax on a scenic boat tour with city views", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Czech Beer Tasting Experience", address: "Various pubs in Prague city center (e.g., U Medvídků, Na Perštýně 7, 110 00 Prague 1)", description: "Sample traditional Czech lagers and learn brewing history", category: "Food & Drink", subcategory: "Craft Beer" },
    { name: "Havelské tržiště Market Visit", address: "Havelské tržiště 13, 110 00 Prague 1", description: "Shop local crafts and fresh produce in the historic market", category: "Cultural", subcategory: "Local Markets" },
    { name: "Prague Jazz Boat Night", address: "Vltava River near Čechův most, 110 00 Prague 1", description: "Enjoy live jazz music while cruising the river", category: "Entertainment", subcategory: "Live Music" },
    { name: "Petřín Hill Hike and Observation Tower", address: "Petřínské sady, 118 00 Prague 1", description: "Climb the tower for panoramic city views and stroll the gardens", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Traditional Czech Cooking Workshop", address: "Cooking studios like Chefparade, Na Florenci 15, 110 00 Prague 1", description: "Learn to cook authentic Czech dishes with a local chef", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Prague Castle Tour", address: "Hradčany, 119 08 Prague 1", description: "Explore the largest ancient castle complex in the world", category: "Cultural", subcategory: "Historic Sites" }
  ]
},

"Switzerland" => {
  "Spiez" => [
    { name: "Spiez Castle Museum Tour", address: "Schlossweg 9, 3700 Spiez", description: "Explore medieval castle history with lake views", category: "Cultural", subcategory: "Historic Sites" },
    { name: "Boat Cruise on Lake Thun", address: "Spiez Hafen, Hafenstrasse 8, 3700 Spiez", description: "Scenic boat ride with mountain panoramas", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Spiez Vineyard Wine Tasting", address: "Weinbau Spiez, Hauptstrasse 15, 3700 Spiez", description: "Taste local Swiss wines and enjoy vineyard views", category: "Food & Drink", subcategory: "Wine Bars / Tasting" },
    { name: "Niederhorn Hiking Trail", address: "Niederhornbahn Talstation, 3700 Beatenberg (near Spiez)", description: "Hike with panoramic views of the Alps", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Spiez Local Market", address: "Marktplatz, 3700 Spiez", description: "Browse fresh produce and local crafts", category: "Cultural", subcategory: "Local Markets" }
  ],

  "Zermatt" => [
    { name: "Matterhorn Glacier Paradise", address: "Matterhorn Glacier Paradise, 3920 Zermatt", description: "Visit highest cable car station with glacier views", category: "Nature & Outdoors", subcategory: "Viewpoints" },
    { name: "Gornergrat Railway Ride", address: "Gornergrat Bahn, Bahnhofstrasse 34, 3920 Zermatt", description: "Mountain train ride with panoramic views", category: "Cultural", subcategory: "Bus City Tours" },
    { name: "Schwarzsee Hiking Trail", address: "Schwarzsee, 3920 Zermatt", description: "Easy hike to mountain lake below the Matterhorn", category: "Nature & Outdoors", subcategory: "Hiking Trails" },
    { name: "Swiss Fondue Cooking Workshop", address: "Local cooking studios or restaurants, Zermatt Town Center", description: "Learn to cook traditional Swiss fondue", category: "Food & Drink", subcategory: "Cooking Workshops" },
    { name: "Zermatt Village Walk", address: "Zermatt Town Center, Bahnhofstrasse, 3920 Zermatt", description: "Walking tour of alpine village architecture", category: "Cultural", subcategory: "Walking City Tours" }
  ],

  "Lucerne" => [
    { name: "Chapel Bridge Walk", address: "Kapellbrücke, 6003 Lucerne", description: "Historic wooden bridge with city views", category: "Cultural", subcategory: "Monuments" },
    { name: "Lake Lucerne Boat Cruise", address: "Lucerne Pier, Zentralstrasse 5, 6003 Lucerne", description: "Boat tour with mountain scenery", category: "Cultural", subcategory: "Boat Tours" },
    { name: "Swiss Museum of Transport", address: "Lidostrasse 5, 6006 Lucerne", description: "Exhibits on transportation and technology", category: "Cultural", subcategory: "History Museums" },
    { name: "Swiss Cheese Tasting", address: "Lucerne Market (Marktgasse), 6004 Lucerne", description: "Try local cheeses and delicacies", category: "Food & Drink", subcategory: "Local Cuisine" },
    { name: "Mount Pilatus Hike", address: "Pilatusbahn Talstation, 6010 Kriens (near Lucerne)", description: "Hiking trail to mountain summit", category: "Nature & Outdoors", subcategory: "Hiking Trails" }
  ],

  "Bern" => [
    { name: "Zytglogge Clock Tower Tour", address: "Kramgasse 49, 3011 Bern", description: "Tour the medieval clock tower", category: "Cultural", subcategory: "Monuments" },
    { name: "Bern Historical Museum", address: "Helvetiaplatz 5, 3005 Bern", description: "History and art exhibits", category: "Cultural", subcategory: "History Museums" },
    { name: "Rosengarten Botanical Gardens", address: "Alter Aargauerstalden 31, 3006 Bern", description: "Explore rose gardens and city views", category: "Nature & Outdoors", subcategory: "Botanical Gardens" },
    { name: "Aare River Walk", address: "Aare River banks, Bern city center", description: "Scenic walk along the river", category: "Nature & Outdoors", subcategory: "Nature Walks" },
    { name: "Bern Craft Beer Tasting", address: "Local breweries like Dampfzentrale, Gerechtigkeitsgasse 38, 3011 Bern", description: "Taste local craft beers", category: "Food & Drink", subcategory: "Craft Beer" },
    { name: "Bern Old Town Market", address: "Bundesplatz and Old Town, 3011 Bern", description: "Shop fresh produce and local goods", category: "Cultural", subcategory: "Local Markets" }
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
  # Pick 3 *random* countries per user
  visited_countries = trip_countries.shuffle.take(3)

  visited_countries.each do |country|
    cities = country_activities[country].keys

    # Pick 3 *random* cities per country
    visited_cities = cities.shuffle.take(3)

    visited_cities.each do |city|
      city_activities = country_activities[country][city]

      start_date = Date.today - rand(60..120)
      end_date = start_date + rand(5..15)
      budget = %w[low medium high].sample

      trip = Trip.create!(
        start_date: start_date,
        end_date: end_date,
        location: "#{city}, #{country}",
        budget: budget,
        user: user
      )

      # Associate activities with the trip
      city_activities.each do |activity_attrs|
        activity = Activity.find_by(name: activity_attrs[:name], location: city)
        next unless activity

        TripActivity.create!(
          trip: trip,
          activity: activity,
          start_time: start_date.to_datetime + rand(9..17).hours,
          end_time: start_date.to_datetime + rand(18..22).hours
        )
      end

      # Estimate trip lat/lon
      lat, lon = avg_lat_lon(city_activities.map { |a| Activity.find_by(name: a[:name], location: city) }.compact)
      trip.update(latitude: lat, longitude: lon) if lat && lon

      # Add a few reviews from this user
      review_count = [city_activities.size, 3].min
      city_activities.first(review_count).each do |activity_attrs|
        activity = Activity.find_by(name: activity_attrs[:name], location: city)
        next unless activity

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
