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

ActiveRecord::Schema.define(version: 2019_02_18_033157) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_finances", primary_key: "company_id", id: :bigint, default: nil, force: :cascade do |t|
    t.integer "bank_code", null: false
    t.integer "agencia", null: false
    t.integer "agencia_dv", null: false
    t.integer "conta", null: false
    t.string "type", null: false
    t.integer "conta_dv", null: false
    t.string "document_number", null: false
    t.string "legal_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_finances_on_company_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "cardid", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "event_venues", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.integer "number", null: false
    t.string "complement"
    t.string "neighborhood", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zipcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.index ["latitude", "longitude"], name: "index_event_venues_on_latitude_and_longitude"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "start_t", null: false
    t.datetime "end_t"
    t.bigint "event_venue_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.string "headline"
    t.string "video"
    t.index ["company_id"], name: "index_events_on_company_id"
    t.index ["event_venue_id"], name: "index_events_on_event_venue_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "offers", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", null: false
    t.integer "available_quantity", null: false
    t.datetime "start_t", null: false
    t.datetime "end_t"
    t.index ["event_id"], name: "index_offers_on_event_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "offer_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_order_items_on_offer_id"
    t.index ["order_id", "offer_id"], name: "index_order_items_on_order_id_and_offer_id", unique: true
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "number", null: false
    t.decimal "subtotal", precision: 10, scale: 2, null: false
    t.decimal "fee", precision: 3, scale: 2, null: false
    t.bigint "user_id", null: false
    t.bigint "order_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", primary_key: "order_id", id: :bigint, default: nil, force: :cascade do |t|
    t.string "tid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "ticket_statuses", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tokens", force: :cascade do |t|
    t.string "code", null: false
    t.string "owner_name", null: false
    t.string "owner_email", null: false
    t.bigint "ticket_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_item_id", null: false
    t.index ["code"], name: "index_ticket_tokens_on_code", unique: true
    t.index ["order_item_id"], name: "index_ticket_tokens_on_order_item_id"
    t.index ["ticket_status_id"], name: "index_ticket_tokens_on_ticket_status_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "cpf"
    t.integer "role", null: false
    t.bigint "company_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.datetime "birthday"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "validations", primary_key: "ticket_token_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_token_id"], name: "index_validations_on_ticket_token_id"
    t.index ["user_id"], name: "index_validations_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_finances", "companies"
  add_foreign_key "credit_cards", "users"
  add_foreign_key "events", "companies"
  add_foreign_key "events", "event_venues"
  add_foreign_key "events", "users"
  add_foreign_key "offers", "events"
  add_foreign_key "order_items", "offers"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "order_statuses"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "ticket_tokens", "order_items"
  add_foreign_key "ticket_tokens", "ticket_statuses"
  add_foreign_key "users", "companies"
end
