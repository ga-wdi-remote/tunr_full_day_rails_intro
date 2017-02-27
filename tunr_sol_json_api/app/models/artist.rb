class Artist < ApplicationRecord
  has_many :songs 
  validates :name, presence: {message: "Name can not be blank"}
  validates :nationality, presence: {message: "Nationality can not be blank"}
  validates :genre, inclusion: { in: ["Electronic", "House", "Jazz", "Indie", "Hip Hop"] }
end
