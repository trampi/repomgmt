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

ActiveRecord::Schema.define(version: 20150123201006) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["task_id"], name: "index_comments_on_task_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "commits", force: :cascade do |t|
    t.integer  "repository_id"
    t.integer  "user_id"
    t.string   "sha"
    t.string   "branch"
    t.text     "message"
    t.datetime "date"
    t.string   "author_email"
    t.string   "author_name"
    t.datetime "commit_date"
    t.string   "committer_email"
    t.string   "committer_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "commits", ["repository_id"], name: "index_commits_on_repository_id"
  add_index "commits", ["user_id"], name: "index_commits_on_user_id"

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_index_date"
    t.integer  "size_in_bytes",   limit: 8
  end

  create_table "repository_accesses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repository_accesses", ["repository_id"], name: "index_repository_accesses_on_repository_id"
  add_index "repository_accesses", ["user_id"], name: "index_repository_accesses_on_user_id"

  create_table "tasks", force: :cascade do |t|
    t.integer  "version_id"
    t.integer  "author_id"
    t.integer  "assignee_id"
    t.string   "title"
    t.text     "message"
    t.boolean  "solved"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repository_id"
  end

  add_index "tasks", ["repository_id"], name: "index_tasks_on_repository_id"
  add_index "tasks", ["version_id"], name: "index_tasks_on_version_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin"
    t.text     "public_key"
    t.string   "gauth_secret"
    t.string   "gauth_enabled",          default: "f"
    t.string   "gauth_tmp"
    t.datetime "gauth_tmp_datetime"
    t.string   "locale"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "name"
    t.date     "due_date"
    t.integer  "repository_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delivered"
  end

  add_index "versions", ["repository_id"], name: "index_versions_on_repository_id"

end
