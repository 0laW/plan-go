class User < ApplicationRecord

  has_many :preferences
  has_many :trips

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
end
