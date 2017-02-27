class Playlist < ApplicationRecord
  has_and_belongs_to_many :songs

  validates :name, presence: true
  validates :name, uniqueness: true

  def add_song(song)
    self.songs.push(song) unless self.songs.include?(song)
  end

  def remove_song(song)
    self.songs.destroy(song) if self.songs.include?(song)
  end

end
