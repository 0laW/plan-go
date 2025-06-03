require "openai"
require 'net/http'
require 'json'

class AiItineraryGenerator
  UNSPLASH_ACCESS_KEY = ENV.fetch('UNSPLASH_ACCESS_KEY', nil) # Set your Unsplash API key in ENV

  def initialize(trip)
    @trip = trip
    @user = trip.user
    @preferences = @user.preferences.includes(:category, :subcategory)
    @client = OpenAI::Client.new
  end

  def generate
    response = @client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: 0.7
      }
    )

    content = response.dig("choices", 0, "message", "content")
    parsed_json = parse_json_from_response(content)

    parsed_json.map do |activity_data|
      category = Category.find_or_create_by(name: activity_data["category"])

      image_url = fetch_unsplash_image(activity_data["name"]) || "https://via.placeholder.com/400x250?text=No+Image"

      activity = Activity.create!(
        name: activity_data["name"],
        description: activity_data["description"],
        address: activity_data["address"],
        rating: activity_data["rating"].to_f,
        location: @trip.location,
        latitude: activity_data["latitude"],
        longitude: activity_data["longitude"],
        category: category,
        image_url: image_url
      )

      TripActivity.create!(
        trip: @trip,
        activity: activity,
        start_time: activity_data["start_time"],
        end_time: activity_data["end_time"]
      )
    end
  end

  private

  def fetch_unsplash_image(query)
    return nil unless UNSPLASH_ACCESS_KEY

    url = URI("https://api.unsplash.com/search/photos?query=#{URI.encode_www_form_component(query)}&per_page=1&client_id=#{UNSPLASH_ACCESS_KEY}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    if data['results'] && data['results'][0] && data['results'][0]['urls'] && data['results'][0]['urls']['regular']
      data['results'][0]['urls']['regular']
    end
  rescue StandardError => e
    Rails.logger.error("Unsplash API error: #{e.message}")
    nil
  end

  def system_prompt
    <<~PROMPT
      You are a travel planner AI that generates structured travel itineraries with time blocks. Each activity should include:
      - name, description, address, rating
      - latitude, longitude, category
      - start_time and end_time in 24-hour format (e.g., "10:00", "12:00")
      - image_url: a relevant image URL representing the activity

      Output must be valid JSON in the format:

      [
        {
          "name": "Park Güell",
          "description": "A famous public park with colorful mosaics designed by Antoni Gaudí.",
          "address": "Carrer d'Olot, 08024 Barcelona, Spain",
          "rating": 4.7,
          "latitude": 41.4145,
          "longitude": 2.1527,
          "category": "Cultural",
          "start_time": "10:00",
          "end_time": "12:00",
          "image_url": "https://example.com/park_guell.jpg"
        }
      ]
    PROMPT
  end

  def user_prompt
    days = (@trip.end_date - @trip.start_date).to_i + 1
    budget_str = case @trip.budget.to_i
                 when 1 then "low"
                 when 2 then "medium"
                 when 3 then "high"
                 else "medium"
                 end

    category_names = @preferences.map { |p| p.category.name }.uniq
    subcategory_names = @preferences.map { |p| p.subcategory&.name }.compact

    <<~PROMPT
      Plan a #{days}-day itinerary for a trip to #{@trip.location} from #{@trip.start_date.strftime('%B %d')} to #{@trip.end_date.strftime('%B %d')}.
      The travel budget is #{budget_str}.

      User prefers: #{category_names.join(', ')}.
      Specific interests: #{subcategory_names.join(', ')}.

      For each day, include no more than 4 activities.
      Provide realistic start and end times for each activity, evenly spread throughout each day.
      Return only valid JSON in the format specified.

      Do not include activities outside the date range.
    PROMPT
  end

  def parse_json_from_response(response_content)
    json_string = response_content[/\[\s*\{.*?\}\s*\]/m]
    JSON.parse(json_string)
  rescue JSON::ParserError => e
    Rails.logger.error("AI JSON Parse Error: #{e.message}")
    raise "Invalid response from AI: #{response_content.truncate(500)}"
  end
end
