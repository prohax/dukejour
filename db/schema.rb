# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091030052044) do

  create_table "entries", :force => true do |t|
    t.integer  "song_id"
    t.datetime "played_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes",      :default => 0, :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "entry_id"
    t.string   "type",       :limit => 16
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libraries", :force => true do |t|
    t.string   "persistent_id", :limit => 16
    t.string   "name",          :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.datetime "imported_at"
    t.integer  "duration"
  end

  create_table "songs", :force => true do |t|
    t.string   "artist",            :limit => 256
    t.string   "album",             :limit => 256
    t.string   "name",              :limit => 256
    t.integer  "year"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "search_artist"
    t.string   "search_name"
    t.string   "normalized_artist"
    t.string   "normalized_album"
    t.string   "normalized_name"
    t.integer  "track_number"
    t.integer  "track_count"
    t.integer  "disc_number"
    t.integer  "disc_count"
  end

  add_index "songs", ["search_artist", "search_name", "duration"], :name => "index_songs_on_search_artist_and_search_name_and_duration"
  add_index "songs", ["search_name", "search_artist", "duration"], :name => "index_songs_on_search_name_and_search_artist_and_duration"

  create_table "tracks", :force => true do |t|
    t.integer  "library_id"
    t.string   "persistent_id", :limit => 16
    t.string   "artist",        :limit => 256
    t.string   "album",         :limit => 256
    t.string   "name",          :limit => 256
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration"
    t.integer  "song_id"
    t.datetime "dirty_at"
    t.integer  "track_number"
    t.integer  "track_count"
    t.integer  "disc_number"
    t.integer  "disc_count"
    t.integer  "bit_rate"
    t.string   "kind",          :limit => 16
  end

  add_index "tracks", ["library_id", "persistent_id"], :name => "index_tracks_on_library_id_and_persistent_id"
  add_index "tracks", ["persistent_id", "library_id"], :name => "index_tracks_on_persistent_id_and_library_id"
  add_index "tracks", ["song_id"], :name => "index_tracks_on_song_id"

end
