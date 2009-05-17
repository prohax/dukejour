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

ActiveRecord::Schema.define(:version => 20090517151802) do

  create_table "accounts", :force => true do |t|
    t.string   "email",                     :limit => 100,                    :null => false
    t.string   "hashed_pass",               :limit => 40
    t.datetime "last_login"
    t.boolean  "show_hints",                                                  :null => false
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.integer  "transfers_count",                          :default => 0,     :null => false
    t.string   "surname",                   :limit => 100
    t.string   "salt",                      :limit => 24
    t.integer  "lastversion",                              :default => 0,     :null => false
    t.string   "recipient_sort",            :limit => 32,  :default => "",    :null => false
    t.integer  "transfers_tally",                          :default => 0,     :null => false
    t.text     "signature"
    t.integer  "creating_board_id"
    t.string   "type",                      :limit => 16,  :default => "",    :null => false
    t.integer  "bandwidth",                 :limit => 8,   :default => 0,     :null => false
    t.integer  "quota",                     :limit => 8,   :default => 0,     :null => false
    t.boolean  "custom_quota",                             :default => false, :null => false
    t.datetime "deleted_at"
    t.boolean  "active",                                   :default => true,  :null => false
    t.string   "given_names",               :limit => 100
    t.string   "kind",                      :limit => 16
    t.datetime "used_at"
    t.integer  "creator_id"
    t.string   "company_name",              :limit => 100
    t.string   "group_name",                :limit => 100
    t.string   "last_login_ip",             :limit => 15
    t.string   "login_token",               :limit => 32
    t.string   "time_zone",                 :limit => 64
    t.integer  "most_recent_membership_id"
  end

  add_index "accounts", ["creating_board_id"], :name => "index_accounts_on_creating_board_id"
  add_index "accounts", ["email"], :name => "index_accounts_on_email"

  create_table "assets", :force => true do |t|
    t.text     "filename",                                        :null => false
    t.string   "content_type",      :limit => 100,                :null => false
    t.integer  "size",              :limit => 8,                  :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "md5",               :limit => 32
    t.string   "sha1",              :limit => 40
    t.integer  "transfer_id"
    t.integer  "bandwidth",         :limit => 8,   :default => 0, :null => false
    t.integer  "downloads",                        :default => 0, :null => false
    t.datetime "collected_at"
    t.datetime "deleted_at"
    t.integer  "creator_id"
    t.integer  "creating_board_id"
  end

  add_index "assets", ["transfer_id"], :name => "index_assets_on_transfer_id"

  create_table "boards", :force => true do |t|
    t.string   "subdomain",             :limit => 64, :default => "",    :null => false
    t.string   "name",                  :limit => 64, :default => "",    :null => false
    t.integer  "transfer_expire_delay",                                  :null => false
    t.integer  "session_expire_delay",                                   :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.datetime "inited_at"
    t.integer  "bandwidth",             :limit => 8,  :default => 0,     :null => false
    t.boolean  "boardwide_quota",                                        :null => false
    t.integer  "quota",                 :limit => 8,  :default => 0,     :null => false
    t.string   "company_url",           :limit => 64,                    :null => false
    t.boolean  "custom_css",                          :default => false, :null => false
    t.datetime "deleted_at"
    t.boolean  "active",                              :default => true,  :null => false
    t.string   "time_zone",             :limit => 64, :default => "UTC", :null => false
  end

  add_index "boards", ["subdomain"], :name => "index_boards_on_subdomain"

  create_table "copies", :force => true do |t|
    t.integer  "transfer_id",                                    :null => false
    t.integer  "recipient_id",                                   :null => false
    t.integer  "downloads",                       :default => 0, :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.datetime "downloaded_at"
    t.datetime "deleted_at"
    t.integer  "creating_board_id"
    t.string   "type",              :limit => 16
    t.integer  "creator_id"
  end

  add_index "copies", ["recipient_id"], :name => "index_copies_on_recipient_id"
  add_index "copies", ["transfer_id"], :name => "index_copies_on_transfer_id"

  create_table "friendships", :force => true do |t|
    t.integer  "account_id"
    t.integer  "friend_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["account_id", "friend_id"], :name => "index_friendships_on_account_id_and_friend_id"
  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"

  create_table "hits", :force => true do |t|
    t.string   "session_id", :limit => 32,  :null => false
    t.integer  "board_id"
    t.integer  "account_id"
    t.string   "ip",         :limit => 15,  :null => false
    t.string   "user_agent", :limit => 192
    t.string   "referer",    :limit => 128
    t.string   "path",       :limit => 128, :null => false
    t.string   "method",     :limit => 8,   :null => false
    t.integer  "response",                  :null => false
    t.datetime "created_at",                :null => false
  end

  create_table "libraries", :force => true do |t|
    t.integer  "id2"
    t.string   "name",       :limit => 256
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "account_id"
    t.string   "email",      :limit => 100
    t.integer  "board_id"
    t.integer  "creator_id"
    t.string   "role",       :limit => 16
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["account_id", "board_id"], :name => "index_memberships_on_account_id_and_board_id"
  add_index "memberships", ["board_id"], :name => "index_memberships_on_board_id"

  create_table "tickets", :force => true do |t|
    t.string   "key",               :limit => 32,  :default => "", :null => false
    t.integer  "account_id",                                       :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "type",              :limit => 16
    t.datetime "notified_at"
    t.datetime "used_at"
    t.datetime "deleted_at"
    t.integer  "creating_board_id"
    t.integer  "copy_id"
    t.string   "email",             :limit => 100
    t.integer  "email_attempts"
  end

  add_index "tickets", ["account_id"], :name => "index_tickets_on_account_id"
  add_index "tickets", ["key"], :name => "index_tickets_on_key"

  create_table "tracks", :force => true do |t|
    t.integer  "library_id"
    t.string   "artist",     :limit => 256
    t.string   "album",      :limit => 256
    t.string   "name",       :limit => 256
    t.string   "year"
    t.string   "integer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "creator_id",                                        :null => false
    t.text     "name"
    t.text     "user_notes"
    t.text     "recipient_notes"
    t.integer  "version",                        :default => 1,     :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "copies_count",                   :default => 0,     :null => false
    t.boolean  "secret",                         :default => false, :null => false
    t.integer  "copies_tally",                   :default => 0,     :null => false
    t.datetime "expired_at"
    t.integer  "creating_board_id",                                 :null => false
    t.datetime "live_at"
    t.datetime "deleted_at"
    t.datetime "confirmed_at"
    t.datetime "uploaded_at"
    t.datetime "collected_at"
    t.integer  "downloads",                      :default => 0
    t.integer  "bandwidth",         :limit => 8, :default => 0
  end

  add_index "transfers", ["creating_board_id"], :name => "index_transfers_on_creating_board_id"
  add_index "transfers", ["creator_id"], :name => "index_transfers_on_creator_id"

  create_table "usage_records", :force => true do |t|
    t.integer "board_id",                               :null => false
    t.integer "account_id",                             :null => false
    t.integer "month",                                  :null => false
    t.integer "bandwidth",  :limit => 8, :default => 0, :null => false
  end

end
