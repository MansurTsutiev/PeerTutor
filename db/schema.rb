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

ActiveRecord::Schema.define(version: 20171229234740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversations", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id", unique: true
    t.index ["sender_id"], name: "index_conversations_on_sender_id", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "subject_id"
    t.string "name"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_courses_on_subject_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "abbrev"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutor_courses", force: :cascade do |t|
    t.bigint "tutor_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_tutor_courses_on_course_id"
    t.index ["tutor_id"], name: "index_tutor_courses_on_tutor_id"
  end

  create_table "tutoring_sessions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tutor_id"
    t.bigint "course_id"
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false
    t.index ["course_id"], name: "index_tutoring_sessions_on_course_id"
    t.index ["tutor_id"], name: "index_tutoring_sessions_on_tutor_id"
    t.index ["user_id"], name: "index_tutoring_sessions_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.boolean "is_tutor", default: false
    t.boolean "is_live", default: false
    t.decimal "total_tip", precision: 10, scale: 2
    t.string "location"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "stripe_account"
    t.string "stripe_id"
    t.float "account_balance", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "courses", "subjects"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "tutor_courses", "courses"
  add_foreign_key "tutor_courses", "users", column: "tutor_id"
  add_foreign_key "tutoring_sessions", "courses"
  add_foreign_key "tutoring_sessions", "users"
  add_foreign_key "tutoring_sessions", "users", column: "tutor_id"
end
