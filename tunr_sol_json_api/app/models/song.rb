class Song < ApplicationRecord
  belongs_to :artist, optional: true
  has_and_belongs_to_many :playlists

  validates :title, :artist_name, :preview_url, :artwork, presence: true
  validates :price, numericality: true, inclusion:  { in: 1..99 }
end
