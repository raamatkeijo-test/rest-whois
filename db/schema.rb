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

ActiveRecord::Schema.define(version: 2020_09_14_073130) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_requests", force: :cascade do |t|
    t.integer "whois_record_id", null: false
    t.string "secret", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.datetime "valid_to", null: false
    t.string "status", default: "new", null: false
    t.inet "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_id"
    t.index ["email"], name: "index_contact_requests_on_email"
    t.index ["ip_address"], name: "index_contact_requests_on_ip_address"
    t.index ["secret"], name: "index_contact_requests_on_secret", unique: true
    t.index ["whois_record_id"], name: "index_contact_requests_on_whois_record_id"
  end

  create_table "whois_records", force: :cascade do |t|
    t.string "name"
    t.json "json"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_domains_on_name"
  end

end
