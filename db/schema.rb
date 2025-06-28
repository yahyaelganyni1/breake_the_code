# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_06_28_151910) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "secret_code"
    t.integer "attempts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_over", default: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "token"
    t.jsonb "metadata"
    t.integer "score"
    t.string "winner_name"
    t.index ["token"], name: "index_games_on_token", unique: true
  end

  create_table "guesses", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "code"
    t.string "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_guesses_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "device_identifier"
    t.string "nickname"
    t.datetime "last_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "metadata"
  end

  add_foreign_key "guesses", "games"
end
