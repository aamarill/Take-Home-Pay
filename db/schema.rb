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

ActiveRecord::Schema.define(version: 20180405080744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "statements", force: :cascade do |t|
    t.float "hourly_rate", null: false
    t.float "overtime_rate", null: false
    t.float "overtime_hours", null: false
    t.float "life_insurance_premium", null: false
    t.float "vision_insurance", null: false
    t.float "health_insurance", null: false
    t.float "fsa_contribution", null: false
    t.float "non_taxable_additional", null: false
    t.float "tax_deferred_additional", null: false
    t.integer "federal_exemptions", null: false
    t.integer "state_exemptions", null: false
    t.integer "additional_state_allowances", null: false
    t.string "home_state", null: false
    t.string "marital_status", null: false
    t.float "tsp_percentage", null: false
    t.float "tsp_fixed_amount", null: false
    t.float "fers_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.float "taxable_additional", null: false
    t.float "roth_tsp_percentage", null: false
    t.float "roth_tsp_fixed_amount", null: false
    t.float "dental_insurance", null: false
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "statements", "users"
end
