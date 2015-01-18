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

ActiveRecord::Schema.define(version: 20150118023929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "map_place_links", force: true do |t|
    t.integer  "map_place_id"
    t.string   "url"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_places", force: true do |t|
    t.integer  "map_id"
    t.string   "title"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "arrived"
    t.text     "description"
    t.integer  "price"
    t.string   "category"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.text     "arrival_path",         default: [], array: true
    t.string   "establishment"
    t.integer  "stay_length",          default: 0
    t.integer  "price_total"
    t.integer  "price_adjusted"
    t.integer  "price_adjusted_total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "arrival_distance"
  end

  create_table "maps", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
