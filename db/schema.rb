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

ActiveRecord::Schema[8.1].define(version: 2026_07_05_030506) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "event_date", null: false
    t.string "form_url"
    t.boolean "hidden", default: false, null: false
    t.string "location"
    t.bigint "organizer_id"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["event_date"], name: "index_events_on_event_date"
    t.index ["hidden"], name: "index_events_on_hidden"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "staff_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_staff_categories_on_name", unique: true
    t.index ["position"], name: "index_staff_categories_on_position"
  end

  create_table "staffs", force: :cascade do |t|
    t.date "birth_date"
    t.string "cargo", null: false
    t.string "carrera"
    t.string "correo"
    t.datetime "created_at", null: false
    t.text "interests"
    t.date "kotonoha_start_date"
    t.string "linkedin_url"
    t.string "nombre", null: false
    t.integer "position"
    t.integer "staff_category_id", null: false
    t.date "university_start_date"
    t.datetime "updated_at", null: false
    t.index ["staff_category_id", "position"], name: "index_staffs_on_staff_category_id_and_position"
    t.index ["staff_category_id"], name: "index_staffs_on_staff_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "staffs", "staff_categories"
end
