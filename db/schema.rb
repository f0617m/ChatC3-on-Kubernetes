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

ActiveRecord::Schema.define(version: 2020_01_20_132240) do

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.string "room_id"
  end

  create_table "rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strokes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "room_id", null: false
    t.string "prevx", null: false
    t.string "prevy", null: false
    t.string "currx", null: false
    t.string "curry", null: false
    t.string "width", null: false
    t.string "color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "name", null: false
    t.string "image_name", null: false
    t.string "password_digest", null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "room_id"
    t.index ["token"], name: "index_users_on_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

end
