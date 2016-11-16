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

ActiveRecord::Schema.define(version: 20161115024339) do

  create_table "activities", force: :cascade do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.text     "notes"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "activity_type"
    t.decimal  "goal",          precision: 8, scale: 2, default: "0.0"
    t.string   "progress"
  end

  create_table "donors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "zip"
    t.string   "phone"
    t.string   "email"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
    t.string   "nickname"
    t.string   "country"
    t.integer  "donor_type"
  end

  create_table "gifts", force: :cascade do |t|
    t.integer  "donor_id"
    t.integer  "activity_id"
    t.date     "donation_date"
    t.text     "notes"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "check_number"
    t.datetime "check_date"
    t.boolean  "anonymous"
    t.text     "memorial_note"
    t.string   "solicited_by"
    t.string   "gift_user"
    t.string   "gift_source"
    t.integer  "gift_type",                             default: 0
    t.decimal  "amount",        precision: 8, scale: 2, default: "0.0"
    t.decimal  "pledge",        precision: 8, scale: 2, default: "0.0"
    t.index ["activity_id"], name: "index_gifts_on_activity_id"
    t.index ["donor_id"], name: "index_gifts_on_donor_id"
  end

  create_table "trashes", force: :cascade do |t|
    t.string   "trash_type"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "username"
    t.integer  "permission_level", default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
