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

ActiveRecord::Schema[7.0].define(version: 2023_06_10_162827) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "gender"
    t.string "password"
    t.string "linkedin"
    t.string "github"
    t.string "account_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts_teams", id: false, force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "team_id", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicants", force: :cascade do |t|
    t.string "status"
    t.string "applicable_type"
    t.bigint "applicable_id"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicable_type", "applicable_id"], name: "index_applicants_on_applicable"
    t.index ["project_id"], name: "index_applicants_on_project_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer "rating"
    t.string "comment"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_feedbacks_on_account_id"
  end

  create_table "payments", force: :cascade do |t|
    t.float "amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_members", force: :cascade do |t|
    t.string "memberable_type"
    t.bigint "memberable_id"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["memberable_type", "memberable_id"], name: "index_project_members_on_memberable"
    t.index ["project_id"], name: "index_project_members_on_project_id"
  end

  create_table "project_statuses", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_statuses_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.float "amount"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id"
    t.string "status"
    t.index ["account_id"], name: "index_projects_on_account_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "level"
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_skills_on_account_id"
  end

  create_table "team_admins", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_team_admins_on_account_id"
    t.index ["team_id"], name: "index_team_admins_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicants", "projects"
  add_foreign_key "feedbacks", "accounts"
  add_foreign_key "project_members", "projects"
  add_foreign_key "project_statuses", "projects"
  add_foreign_key "projects", "accounts"
  add_foreign_key "skills", "accounts"
  add_foreign_key "team_admins", "accounts"
  add_foreign_key "team_admins", "teams"
end
