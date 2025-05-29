class Category < ApplicationRecord
  has_many :subcategories
  has_many :activities
end
