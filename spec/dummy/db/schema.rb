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

ActiveRecord::Schema.define(version: 20151201151542) do

  create_table "conduit_requests", force: true do |t|
    t.string   "driver"
    t.string   "action"
    t.text     "options"
    t.string   "file"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "last_error_message"
    t.string   "transaction_id"
  end

  create_table "conduit_responses", force: true do |t|
    t.string   "file"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conduit_responses", ["request_id"], name: "index_conduit_responses_on_request_id"

  create_table "conduit_subscriptions", force: true do |t|
    t.integer  "request_id"
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "responder_type"
    t.text     "responder_options"
  end

  add_index "conduit_subscriptions", ["request_id"], name: "index_conduit_subscriptions_on_request_id"
  add_index "conduit_subscriptions", ["subscriber_type", "subscriber_id"], name: "index_conduit_subscriptions_on_subscriber"

end
