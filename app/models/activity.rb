class Activity < ApplicationRecord
  belongs_to :category
  has_many :trip_reviews
  has_many :activity_reviews
  has_many :trip_activities
  has_many :trips, through: :trip_activities

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  after_create :fetch_and_update_image_url

  def fetch_and_update_image_url
    puts "Updating image for activity ##{id}: #{name}"

    api_key = ENV.fetch('GOOGLE_PLACES_API_KEY', nil)
    unless api_key&.present?
      puts "API key missing!"
      return
    end

    query = URI.encode_www_form_component("#{name} #{location}")
    location_bias = "circle:2000@#{latitude},#{longitude}"
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{query}&inputtype=textquery&fields=photos,place_id&locationbias=#{location_bias}&key=#{api_key}"

    puts "Requesting: #{url}"

    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)

    puts "Response from Google Places API:"
    puts JSON.pretty_generate(data)

    if (candidate = data['candidates']&.first) && candidate['photos']
      photo_ref = candidate['photos'].first['photo_reference']
      photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=#{photo_ref}&key=#{api_key}"
      puts "Photo found! Setting image URL: #{photo_url}"
      update(image_url: photo_url)
    else
      puts "No photos found for #{name}"
      update(image_url: nil)
    end
  rescue StandardError => e
    puts "Error fetching image for activity ##{id}: #{e.message}"
  end
end
