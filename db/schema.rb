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

ActiveRecord::Schema.define(version: 2020_05_15_162021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.string "notes"
    t.float "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "raider_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.integer "user_id"
    t.integer "news_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["news_post_id"], name: "index_comments_on_news_post_id"
    t.index ["user_id", "news_post_id"], name: "index_comments_on_user_id_and_news_post_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.string "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zone"
    t.text "winner"
    t.string "classification", default: "Unlimited"
    t.string "category"
  end

  create_table "news_posts", force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.integer "ranking"
    t.integer "raider_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "phase", default: 3
    t.boolean "locked", default: true
  end

  create_table "raiders", force: :cascade do |t|
    t.string "name"
    t.string "which_class"
    t.string "role"
    t.float "total_points_earned", default: 0.0
    t.float "total_points_spent", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "raids", force: :cascade do |t|
    t.string "name"
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "raid_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes", default: ""
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "char_name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "approved", default: false, null: false
    t.integer "raider_id"
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "winners", force: :cascade do |t|
    t.float "points_spent"
    t.integer "raider_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
