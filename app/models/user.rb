class User < ApplicationRecord
  has_many :preferences

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
