# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090203144234) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["name"], :name => "index_authors_on_name"

  create_table "authorships", :force => true do |t|
    t.integer  "author_id"
    t.integer  "code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorships", ["author_id"], :name => "index_authorships_on_author_id"
  add_index "authorships", ["code_id"], :name => "index_authorships_on_code_id"

  create_table "codes", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "homepage"
    t.string   "rubyforge"
    t.string   "github"
    t.string   "code_type"
    t.string   "slug_name"
    t.decimal  "latest_version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0
    t.text     "summary"
  end

  add_index "codes", ["comments_count"], :name => "index_codes_on_comments_count"
  add_index "codes", ["name"], :name => "index_codes_on_name"
  add_index "codes", ["updated_at"], :name => "index_codes_on_updated_at"

  create_table "comments", :force => true do |t|
    t.integer  "code_id"
    t.integer  "platform_id"
    t.text     "body"
    t.boolean  "works_for_me"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",        :default => ""
  end

  add_index "comments", ["code_id"], :name => "index_comments_on_code_id"
  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "platforms", ["name"], :name => "index_platforms_on_name"

end
