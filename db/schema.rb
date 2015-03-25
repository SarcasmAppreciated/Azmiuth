# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150308080129) do

  create_table "authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string  "secret"
    t.string  "token"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id"

  create_table "icebergs", force: :cascade do |t|
    t.integer  "berg_number"
    t.date     "date"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "size"
    t.string   "shape"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "user_id"
    t.float   "destination_latitude"
    t.float   "destination_longitude"
  end

  add_index "preferences", ["user_id"], name: "index_preferences_on_user_id"

  create_table "tweets", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "tweet_text"
    t.datetime "time_stamp"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "tweet_id",   limit: 8
  end

  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string  "name",                        default: "", null: false
    t.string  "user_name",                   default: "", null: false
    t.string  "profile_image_url",           default: "", null: false
    t.integer "user_id",           limit: 8
  end

  add_index "users", ["user_id"], name: "index_users_on_user_id", unique: true

end
