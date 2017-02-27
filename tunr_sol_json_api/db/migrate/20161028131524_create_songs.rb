class CreateSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist_name
      t.string :preview_url
      t.string :artwork
      t.integer :price

      t.timestamps
    end
  end
end
