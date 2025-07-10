module UsersHelper
def level_badge_color(level)
  colors = {
    "Wanderer" => "green",
    "Explorer" => "pink",
    "Trailblazer" => "blue",
    "Pathfinder" => "green",
    "Wayfarer" => "yellow",
    "Adventurer" => "orange",
    "Globetrotter" => "brown",
    "Trailmaster" => "purple",
    "Nomad" => "red",
    "World Conqueror" => "gold"
  }

  colors[level] || "green" # fallback
end
end
