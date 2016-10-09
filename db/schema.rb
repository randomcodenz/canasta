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

ActiveRecord::Schema.define(version: 20161008180242) do

  create_table "card_ranks", force: :cascade do |t|
    t.string   "rank",       limit: 10, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "card_ranks", ["rank"], name: "index_card_ranks_on_rank", unique: true

  create_table "card_suits", force: :cascade do |t|
    t.string   "suit",       limit: 10, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "card_suits", ["suit"], name: "index_card_suits_on_suit", unique: true

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_action_cards", force: :cascade do |t|
    t.integer  "card_rank_id",     null: false
    t.integer  "card_suit_id",     null: false
    t.integer  "player_action_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "player_action_cards", ["card_rank_id"], name: "index_player_action_cards_on_card_rank_id"
  add_index "player_action_cards", ["card_suit_id"], name: "index_player_action_cards_on_card_suit_id"
  add_index "player_action_cards", ["player_action_id"], name: "index_player_action_cards_on_player_action_id"

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
