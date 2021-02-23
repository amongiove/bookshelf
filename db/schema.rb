# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_20_180145) do

  create_table "book_genres", force: :cascade do |t|
    t.integer "book_id"
    t.integer "genre_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.integer "created_by_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "book_id"
    t.integer "user_id"
    t.integer "rating_value"
    t.text "review"
  end

  create_table "user_books", force: :cascade do |t|
    t.integer "user_id"
    t.integer "book_id"
    t.boolean "read"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
  end

end
