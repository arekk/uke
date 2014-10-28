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

ActiveRecord::Schema.define(version: 20140813153407) do

  create_table "bandplans", force: true do |t|
    t.decimal  "mhz_start",   precision: 10, scale: 4, null: false
    t.decimal  "mhz_end",     precision: 10, scale: 4, null: false
    t.decimal  "step",        precision: 5,  scale: 2
    t.string   "purpose"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bandplans", ["mhz_start", "mhz_end"], name: "index_bandplans_on_mhz_start_and_mhz_end", using: :btree

  create_table "frequencies", force: true do |t|
    t.decimal  "mhz",        precision: 10, scale: 4
    t.decimal  "step",       precision: 5,  scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "frequencies", ["mhz"], name: "index_frequencies_on_mhz", using: :btree

  create_table "frequency_assignments", force: true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "frequency_id"
    t.string   "usage",         limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uke_import_id"
  end

  add_index "frequency_assignments", ["frequency_id"], name: "index_assigned_frequencies_on_frequency_id", using: :btree
  add_index "frequency_assignments", ["subject_type", "subject_id", "usage"], name: "assigned_frequencies_on_subject_usage", using: :btree
  add_index "frequency_assignments", ["subject_type", "subject_id"], name: "index_assigned_frequencies_on_subject_type_and_subject_id", using: :btree
  add_index "frequency_assignments", ["uke_import_id"], name: "index_frequency_assignments_on_uke_import_id", using: :btree

  create_table "log_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "log_id"
    t.text     "description"
    t.integer  "level"
    t.string   "net",                             limit: 1
    t.integer  "related_frequency_assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lon",                                       precision: 10, scale: 6
    t.decimal  "lat",                                       precision: 10, scale: 6
    t.string   "street_address"
    t.string   "administrative_area_level_3"
    t.string   "administrative_area_level_2"
    t.string   "administrative_area_level_1"
    t.string   "country"
  end

  add_index "log_entries", ["log_id"], name: "index_log_entries_on_log_id", using: :btree
  add_index "log_entries", ["related_frequency_assignment_id"], name: "index_log_entries_on_related_frequency_assignment_id", using: :btree
  add_index "log_entries", ["user_id"], name: "index_log_entries_on_user_id", using: :btree

  create_table "logs", force: true do |t|
    t.string   "name"
    t.text     "remarks"
    t.integer  "user_id"
    t.integer  "location_precision",                                   default: 0
    t.decimal  "lon",                         precision: 10, scale: 6
    t.decimal  "lat",                         precision: 10, scale: 6
    t.string   "street_address"
    t.string   "administrative_area_level_3"
    t.string   "administrative_area_level_2"
    t.string   "administrative_area_level_1"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["user_id"], name: "index_logs_on_user_id", using: :btree

  create_table "uke_import_news", force: true do |t|
    t.integer  "uke_import_id"
    t.integer  "uke_station_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uke_import_news", ["uke_import_id", "uke_station_id"], name: "index_uke_import_news_on_uke_import_id_and_uke_station_id", using: :btree
  add_index "uke_import_news", ["uke_import_id"], name: "index_uke_import_news_on_uke_import_id", using: :btree
  add_index "uke_import_news", ["uke_station_id"], name: "index_uke_import_news_on_uke_station_id", using: :btree

  create_table "uke_imports", force: true do |t|
    t.date     "released_on"
    t.boolean  "active",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uke_imports", ["active"], name: "index_uke_imports_on_active", using: :btree

  create_table "uke_operators", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "name_unified"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uke_operators", ["name_unified"], name: "index_uke_operators_on_name_unified", using: :btree

  create_table "uke_permits", force: true do |t|
    t.string   "number"
    t.date     "valid_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uke_permits", ["valid_to"], name: "index_uke_permits_on_valid_to", using: :btree

  create_table "uke_stations", force: true do |t|
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
    t.string   "ant_polarisation",  limit: 2
    t.boolean  "directional"
    t.integer  "uke_operator_id"
    t.integer  "uke_permit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_unified",                                                     null: false
    t.integer  "uke_import_id",                                        default: 1
  end

  add_index "uke_stations", ["lon", "lat"], name: "index_uke_stations_on_lon_and_lat", using: :btree
  add_index "uke_stations", ["name_unified"], name: "index_uke_stations_on_name_unified", using: :btree
  add_index "uke_stations", ["uke_import_id"], name: "index_uke_stations_on_uke_import_id", using: :btree
  add_index "uke_stations", ["uke_operator_id"], name: "index_uke_stations_on_uke_operator_id", using: :btree
  add_index "uke_stations", ["uke_permit_id"], name: "index_uke_stations_on_uke_permit_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",         default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "location"
    t.string   "scanner_model"
    t.string   "trx_model"
    t.string   "radioscaner_forum_login"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
