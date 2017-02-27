# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161031153744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.text     "img_url"
    t.string   "nationality"
    t.string   "genre"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name"
  end

  create_table "playlists_songs", id: false, force: :cascade do |t|
    t.integer "playlist_id", null: false
    t.integer "song_id",     null: false
    t.index ["playlist_id", "song_id"], name: "index_playlists_songs_on_playlist_id_and_song_id", using: :btree
    t.index ["song_id", "playlist_id"], name: "index_playlists_songs_on_song_id_and_playlist_id", using: :btree
  end

  create_table "songs", force: :cascade do |t|
    t.string   "title"
    t.string   "artist_name"
    t.string   "preview_url"
    t.string   "artwork"
    t.integer  "price"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "artist_id"
    t.index ["artist_id"], name: "index_songs_on_artist_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  add_foreign_key "songs", "artists"
end
