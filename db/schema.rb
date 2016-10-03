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

ActiveRecord::Schema.define(version: 20161003042358) do

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_actions", force: :cascade do |t|
    t.string   "type",       null: false
    t.integer  "round_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "card_name"
  end

  add_index "player_actions", ["round_id"], name: "index_player_actions_on_round_id"

  create_table "players", force: :cascade do |t|
    t.string   "name",       limit: 50, null: false
    t.integer  "game_id",               null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "players", ["game_id", "name"], name: "index_players_on_game_id_and_name", unique: true
  add_index "players", ["game_id"], name: "index_players_on_game_id"

  create_table "rounds", force: :cascade do |t|
    t.integer  "game_id",              null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "deck_seed",  limit: 8, null: false
  end

  add_index "rounds", ["game_id"], name: "index_rounds_on_game_id"

end
