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

ActiveRecord::Schema.define(version: 2019_01_14_145152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.integer "year"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "winner_id"
    t.index ["winner_id"], name: "index_competitions_on_winner_id"
  end

  create_table "competitions_groups", force: :cascade do |t|
    t.bigint "competition_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_competitions_groups_on_competition_id"
    t.index ["group_id"], name: "index_competitions_groups_on_group_id"
  end

  create_table "competitions_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "competition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_competitions_users_on_competition_id"
    t.index ["user_id"], name: "index_competitions_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "groups_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "first_team_id", null: false
    t.integer "second_team_id", null: false
    t.datetime "played", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_id"
    t.integer "first_score"
    t.integer "second_score"
    t.string "bet"
    t.index ["first_team_id"], name: "index_matches_on_first_team_id"
    t.index ["round_id"], name: "index_matches_on_round_id"
    t.index ["second_team_id"], name: "index_matches_on_second_team_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "competition_id"
    t.integer "stage"
    t.index ["competition_id"], name: "index_rounds_on_competition_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.string "flag"
    t.string "name_en"
    t.text "photo"
  end

  create_table "types", force: :cascade do |t|
    t.integer "user_id"
    t.integer "match_id"
    t.integer "first_score"
    t.integer "second_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bet"
    t.index ["match_id"], name: "index_types_on_match_id"
    t.index ["user_id"], name: "index_types_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.datetime "deleted_at"
    t.boolean "take_part", default: true
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.text "tokens"
    t.text "photo"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "winner_types", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "user_id"
    t.bigint "competition_id"
    t.index ["competition_id"], name: "index_winner_types_on_competition_id"
    t.index ["team_id"], name: "index_winner_types_on_team_id"
    t.index ["user_id"], name: "index_winner_types_on_user_id"
  end

  add_foreign_key "competitions_groups", "competitions"
  add_foreign_key "competitions_groups", "groups"
  add_foreign_key "competitions_users", "competitions"
  add_foreign_key "competitions_users", "users"
  add_foreign_key "groups_users", "groups"
  add_foreign_key "groups_users", "users"
  add_foreign_key "winner_types", "competitions"
  add_foreign_key "winner_types", "teams"
  add_foreign_key "winner_types", "users"
end
