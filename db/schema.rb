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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120606124732) do

  create_table "business_plans", :force => true do |t|
    t.boolean  "public"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "company_id"
    t.boolean  "waiting",    :default => false
    t.boolean  "verified",   :default => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.decimal  "fixedCost",       :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "variableCost",    :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "revenue",         :precision => 5, :scale => 2, :default => 0.0
    t.decimal  "profit",          :precision => 5, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "group_id"
    t.integer  "max_capacity"
    t.integer  "capacity",                                      :default => 0
    t.integer  "max_quality"
    t.integer  "quality",                                       :default => 0
    t.integer  "penetration",                                   :default => 0
    t.integer  "max_penetration"
    t.string   "service_type"
    t.boolean  "initialised",                                   :default => false
    t.string   "about_us"
    t.integer  "size"
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "needs", :force => true do |t|
    t.integer  "needer_id"
    t.integer  "needed_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "needs", ["needed_id"], :name => "index_needs_on_needed_id"
  add_index "needs", ["needer_id", "needed_id"], :name => "index_needs_on_needer_id_and_needed_id", :unique => true
  add_index "needs", ["needer_id"], :name => "index_needs_on_needer_id"

  create_table "plan_parts", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "business_plan_id"
  end

  create_table "rfps", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "content"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "rfps", ["receiver_id"], :name => "index_rfps_on_receiver_id"
  add_index "rfps", ["sender_id"], :name => "index_rfps_on_sender_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "studentNumber"
    t.string   "department"
    t.string   "role"
    t.boolean  "isTeacher",       :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "group_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
