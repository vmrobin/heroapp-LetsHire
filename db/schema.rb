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

ActiveRecord::Schema.define(:version => 20130322093032) do

  create_table "departments", :force => true do |t|
    t.string "name",        :null => false
    t.string "description"
  end

  add_index "departments", ["name"], :name => "index_departments_on_name", :unique => true

  create_table "interviews", :force => true do |t|
    t.string   "type",         :null => false
    t.string   "title",        :null => false
    t.text     "description"
    t.string   "status"
    t.float    "score"
    t.text     "assessment"
    t.datetime "scheduled_at", :null => false
    t.integer  "duration"
    t.string   "phone"
    t.string   "location"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "opening_participants", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "opening_id"
  end

  add_index "opening_participants", ["opening_id"], :name => "index_opening_participants_on_opening_id"
  add_index "opening_participants", ["user_id"], :name => "index_opening_participants_on_user_id"

  create_table "openings", :force => true do |t|
    t.string   "title"
    t.string   "country"
    t.string   "province"
    t.integer  "department_id"
    t.integer  "hiring_manager_id"
    t.integer  "recruiter_id"
    t.string   "description"
    t.integer  "status",            :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "city"
  end

  create_table "users", :force => true do |t|
    t.string   "email",              :default => "",    :null => false
    t.string   "encrypted_password", :default => "",    :null => false
    t.string   "name"
    t.boolean  "admin",              :default => false, :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "department_id"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
