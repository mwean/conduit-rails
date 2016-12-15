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

ActiveRecord::Schema.define(version: 20161214153509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conduit_requests", force: :cascade do |t|
    t.string   "driver"
    t.string   "action"
    t.text     "options"
    t.string   "file"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "last_error_message"
    t.string   "transaction_id"
    t.integer  "parent_id"
    t.text     "stored_state"
  end

  create_table "conduit_responses", force: :cascade do |t|
    t.string   "file"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conduit_responses", ["request_id"], name: "index_conduit_responses_on_request_id", using: :btree

  create_table "conduit_subscriptions", force: :cascade do |t|
    t.integer  "request_id"
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "responder_type"
    t.json     "responder_options"
  end

  add_index "conduit_subscriptions", ["request_id"], name: "index_conduit_subscriptions_on_request_id", using: :btree
  add_index "conduit_subscriptions", ["subscriber_type", "subscriber_id"], name: "index_conduit_subscriptions_on_subscriber", using: :btree

end
