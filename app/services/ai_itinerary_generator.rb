require 'json'
require 'uri'
require 'net/http'
require 'time'

class AiItineraryGenerator
  def initialize(trip, preferences, budget)
    @trip = trip
    @preferences = preferences
    @budget = budget.to_f
    @client = OpenAI::Client.new
  end

  def generate
    response = @client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: 0.7
      }
    )

    ai_content = response.dig("choices", 0, "message", "content")
    activities_data = parse_json_from_response(ai_content)

    days_count = (@trip.end_date - @trip.start_date).to_i + 1
    max_activities = days_count * 3

    activities_data.select! { |a| (1..days_count).include?(a["day"]) }
    activities_data = activities_data.first(max_activities)

    activities_by_day = activities_data.group_by { |a| a["day"] || 1 }
    filtered_activities = []

    activities_by_day.each do |day, acts|
      selected_acts = acts.first(3) # exactly 3 activities per day
      fixed_acts = selected_acts
      filtered_activities.concat(fixed_acts)
    end

    total_cost = filtered_activities.sum { |a| parse_cost(a["cost"]) }
    scale_factor = total_cost.positive? ? @budget / total_cost : 1.0

    filtered_activities.each do |activity_data|
      category = Category.find_or_create_by(name: activity_data["category"])

      activity = Activity.find_or_initialize_by(
        name: activity_data["name"],
        location: @trip.location
      )

      activity.description  = activity_data["description"]
      activity.address      = activity_data["address"]
      activity.rating       = activity_data["rating"].to_f
      activity.latitude     = activity_data["latitude"]
      activity.longitude    = activity_data["longitude"]
      activity.category     = category
      activity.price_level  = activity_data["price_level"] || "Unknown"

      raw_cost = parse_cost(activity_data["cost"])
      scaled_cost = (raw_cost * scale_factor).ceil
      activity.cost = format_cost(scaled_cost, activity_data["cost"])

      activity.save!

      TripActivity.create!(
        trip: @trip,
        activity: activity,
        start_time: activity_data["start_time"],
        end_time: activity_data["end_time"],
        day: activity_data["day"]
      )
    end
  end

  private

  def fix_time_blocks(activities, _day)
    base_time = Time.parse("10:00")
    activities.each_with_index.map do |act, index|
      start_time = base_time + (index * 2.5 * 3600) # 2.5-hour gaps
      end_time = start_time + (2 * 3600)            # 2-hour activity
      act["start_time"] = start_time.strftime("%H:%M")
      act["end_time"] = end_time.strftime("%H:%M")
      act
    end
  end

  def parse_cost(cost_str)
    return 0.0 unless cost_str.respond_to?(:gsub)

    cost_str.gsub(/[^\d\.]/, '').to_f
  end

  def format_cost(amount, original_cost_str)
    return nil unless original_cost_str.respond_to?(:strip) && !original_cost_str.strip.empty?

    symbol = original_cost_str.strip[0]
    "#{symbol}#{amount}"
  end

  def system_prompt
    <<~PROMPT
      You are a travel planner AI that generates structured travel itineraries with time blocks.
      Each activity must include:
      - name, description, address, rating
      - latitude, longitude, category
      - start_time and end_time in 24-hour format (e.g., "10:00", "12:00")
      - price_level: one of "$", "$$", "$$$"
      - cost as a string with currency symbol, e.g. "€15", "£30", "$40"

      Do NOT include image URLs.

      Return output as a valid JSON array like:

      [
        {
          "day": 1,
          "name": "Park Güell",
          "description": "Colorful Gaudí-designed park with panoramic city views.",
          "address": "Carrer d'Olot, Barcelona",
          "rating": 4.7,
          "latitude": 41.4145,
          "longitude": 2.1527,
          "category": "Cultural",
          "start_time": "10:00",
          "end_time": "12:00",
          "price_level": "$$",
          "cost": "€15"
        }
      ]

      Ensure the total cost for all activities across all days sums roughly to the user's budget.
      Suggest exactly 3 activities per day with non-overlapping time slots.
    PROMPT
  end

  def user_prompt
    days = (@trip.end_date - @trip.start_date).to_i + 1
    category_names = @preferences.map { |p| p.category.name }.uniq
    subcategory_names = @preferences.map { |p| p.subcategory&.name }.compact

    <<~PROMPT
      Plan a #{days}-day itinerary in #{@trip.location} from #{@trip.start_date.strftime('%B %d')} to #{@trip.end_date.strftime('%B %d')}.
      For each day, suggest exactly 3 unique activities with sequential, non-overlapping time slots.

      User preferences include: #{category_names.join(', ')}.
      Specific interests: #{subcategory_names.join(', ')}.

      The total cost of all activities for the whole trip should be about #{@budget} (user's budget).

      Make sure you output exactly #{days * 3} activities in total.

      Each activity must have:
      - start and end times
      - activities are always grouped in 3's regarding the day that they are on (day 1 = 3 activities, day 2 = 3 activities ) so ensure that each 3 activities fall within 07:00 and 19:00 - and never have an activity in the same group of 3 clashing times.
      - a real location (with latitude and longitude)
      - a description (if its a high budget input from the user, explain how the user can spend their money)
      - a price level ($, $$, or $$$)
      - an estimated cost with currency symbol (rounded up to nearest pound). be smart about it, for example if somebody puts in budget 5000, dont just hike the estimated cost up for a standard activity such as a trip to a park.  Give niche things to do like expensive meals (Nusr-et for example) or specific expensive activies rather than just say Regents Park £300 for the day.

      Output the result as a valid JSON array of all activities, including a "day" field with values from 1 to #{days}.
    PROMPT
  end

  def parse_json_from_response(content)
    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error("AI JSON Parse Error: #{e.message}")
    []
  end
end
