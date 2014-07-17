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

ActiveRecord::Schema.define(version: 20140716142724) do

  create_table "frequencies", force: true do |t|
    t.string   "usage",      limit: 2
    t.decimal  "mhz",                  precision: 10, scale: 4
    t.decimal  "step",                 precision: 5,  scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frequencies", ["mhz"], name: "index_frequencies_on_mhz", using: :btree

  create_table "frequencies_stations", id: false, force: true do |t|
    t.integer "frequency_id", null: false
    t.integer "station_id",   null: false
  end

  add_index "frequencies_stations", ["frequency_id"], name: "index_frequencies_stations_on_frequency_id", using: :btree
  add_index "frequencies_stations", ["station_id"], name: "index_frequencies_stations_on_station_id", using: :btree

  create_table "operators", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "name_unified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operators", ["name_unified"], name: "index_operators_on_name_unified", using: :btree

  create_table "permits", force: true do |t|
    t.string   "number"
    t.date     "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permits", ["valid_to"], name: "index_permits_on_valid_to", using: :btree

  create_table "stations", force: true do |t|
    t.string   "name"
    t.string   "purpose",           limit: 2
    t.string   "net",               limit: 1
    t.decimal  "lon",                         precision: 10, scale: 6
    t.decimal  "lat",                         precision: 10, scale: 6
    t.integer  "radius"
    t.string   "location"
    t.string   "location_geocoded"
    t.decimal  "erp",                         precision: 5,  scale: 1
    t.decimal  "ant_efficiency",              precision: 5,  scale: 1
    t.integer  "ant_height"
    t.string   "ant_polarisation",  limit: 1
    t.boolean  "directional"
    t.integer  "operator_id"
    t.integer  "permit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stations", ["lon", "lat"], name: "index_stations_on_lon_and_lat", using: :btree
  add_index "stations", ["operator_id"], name: "index_stations_on_operator_id", using: :btree
  add_index "stations", ["permit_id"], name: "index_stations_on_permit_id", using: :btree

end
