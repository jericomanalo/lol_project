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

ActiveRecord::Schema.define(version: 20160630204735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "champion_masteries", force: :cascade do |t|
    t.integer  "summoner_id"
    t.integer  "championPointsSinceLastLevel"
    t.integer  "championPointsUntilNextLevel"
    t.integer  "championLevel"
    t.integer  "lastPlayTime"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "current_points"
    t.integer  "tokensEarned"
    t.string   "chestGranted"
    t.integer  "champion_id"
  end

  add_index "champion_masteries", ["champion_id"], name: "index_champion_masteries_on_champion_id", using: :btree
  add_index "champion_masteries", ["summoner_id"], name: "index_champion_masteries_on_summoner_id", using: :btree

  create_table "champions", force: :cascade do |t|
    t.integer  "championId"
    t.string   "name"
    t.string   "title"
    t.string   "icon"
    t.string   "splash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "tag"
  end

  create_table "champs", force: :cascade do |t|
    t.integer  "champion_id"
    t.integer  "match_id"
    t.integer  "champion_mastery_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "champs", ["champion_id"], name: "index_champs_on_champion_id", using: :btree
  add_index "champs", ["champion_mastery_id"], name: "index_champs_on_champion_mastery_id", using: :btree
  add_index "champs", ["match_id"], name: "index_champs_on_match_id", using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "summoner_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "favorites", ["summoner_id"], name: "index_favorites_on_summoner_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "matchId",        limit: 8
    t.integer  "summonerId",     limit: 8
    t.integer  "kills",          limit: 8
    t.integer  "deaths",         limit: 8
    t.integer  "assists",        limit: 8
    t.integer  "goldEarned",     limit: 8
    t.integer  "summonerSpell1", limit: 8
    t.integer  "summonerSpell2", limit: 8
    t.integer  "item1",          limit: 8
    t.integer  "item2",          limit: 8
    t.integer  "item3",          limit: 8
    t.integer  "item4",          limit: 8
    t.integer  "item5",          limit: 8
    t.integer  "item6",          limit: 8
    t.integer  "mastery",        limit: 8
    t.integer  "cs",             limit: 8
    t.integer  "jungleCs",       limit: 8
    t.integer  "totalDamage",    limit: 8
    t.integer  "totalHeal",      limit: 8
    t.integer  "totalCcDealt",   limit: 8
    t.integer  "magicDamage",    limit: 8
    t.integer  "physicalDamage", limit: 8
    t.integer  "damageTaken",    limit: 8
    t.integer  "wardsPlaced",    limit: 8
    t.integer  "doubleKills",    limit: 8
    t.integer  "tripleKills",    limit: 8
    t.integer  "quadraKills",    limit: 8
    t.integer  "pentaKills",     limit: 8
    t.string   "win"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "championLevel",  limit: 8
    t.integer  "summoner_id"
    t.integer  "timestamp",      limit: 8
    t.integer  "masteryPoints"
    t.integer  "mdScore"
    t.integer  "champion_id"
  end

  add_index "matches", ["champion_id"], name: "index_matches_on_champion_id", using: :btree
  add_index "matches", ["summoner_id"], name: "index_matches_on_summoner_id", using: :btree

  create_table "summoners", force: :cascade do |t|
    t.string   "summonerName"
    t.integer  "summonerId"
    t.string   "region"
    t.string   "icon"
    t.integer  "summonerLevel"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "summoner_id"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "bio"
  end

  add_index "users", ["summoner_id"], name: "index_users_on_summoner_id", using: :btree

  add_foreign_key "champion_masteries", "summoners"
  add_foreign_key "champs", "champion_masteries"
  add_foreign_key "champs", "champions"
  add_foreign_key "champs", "matches"
  add_foreign_key "favorites", "summoners"
  add_foreign_key "favorites", "users"
  add_foreign_key "matches", "summoners"
end
