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

ActiveRecord::Schema.define(version: 2019_01_31_051622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_finance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_finance_id"], name: "index_companies_on_company_finance_id"
  end

  create_table "company_finances", force: :cascade do |t|
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
    t.bigint "payment_id", null: false
    t.bigint "order_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["order_status_id"], name: "index_orders_on_order_status_id"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "tid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "validation_id"
    t.bigint "ticket_status_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_item_id"
    t.index ["code"], name: "index_ticket_tokens_on_code", unique: true
    t.index ["order_item_id"], name: "index_ticket_tokens_on_order_item_id"
    t.index ["ticket_status_id"], name: "index_ticket_tokens_on_ticket_status_id"
    t.index ["validation_id"], name: "index_ticket_tokens_on_validation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.integer "age", null: false
    t.string "cpf", null: false
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
    t.string "gender", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "validations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_validations_on_user_id"
  end

end
