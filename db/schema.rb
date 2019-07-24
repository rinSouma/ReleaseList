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

ActiveRecord::Schema.define(version: 20190724180304) do

  create_table "affiliates", force: :cascade do |t|
    t.string "itemName"
    t.string "catchcopy"
    t.string "itemCode"
    t.string "itemPrice"
    t.string "itemCaption"
    t.string "itemUrl"
    t.string "affiliateUrl"
    t.string "smallImageUrls"
    t.string "mediumImageUrls"
    t.string "taxFlag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lists", id: :string, force: :cascade do |t|
    t.integer "genre"
    t.string "isbn"
    t.string "title"
    t.string "auther"
    t.string "label_name"
    t.integer "label_id"
    t.date "release_date"
    t.integer "decision_flg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "sqlite_autoindex_lists_1", unique: true
  end

end
