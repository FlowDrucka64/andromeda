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

ActiveRecord::Schema[7.0].define(version: 2022_04_09_111718) do
  create_table "course_favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_number"
    t.integer "dsw_id"
    t.integer "dsr_id"
    t.string "semester"
    t.string "notes"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_course_favourites_on_user_id"
  end

  create_table "project_favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "notes"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_project_favourites_on_user_id"
  end

  create_table "staff_favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "staff_id"
    t.string "notes"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_staff_favourites_on_user_id"
  end

  create_table "thesis_favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "thesis_id"
    t.integer "dsw_id"
    t.integer "dsr_id"
    t.string "notes"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_thesis_favourites_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
