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

ActiveRecord::Schema.define(version: 20140627072930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colorschemas", force: true do |t|
    t.string   "title",                        null: false
    t.text     "body",                         null: false
    t.integer  "user_id",                      null: false
    t.string   "colorschema_img", default: ""
    t.string   "slug",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "colorschemas", ["slug"], name: "index_colorschemas_on_slug", unique: true, using: :btree
  add_index "colorschemas", ["title"], name: "index_colorschemas_on_title", using: :btree

  create_table "dotfiles", force: true do |t|
    t.string   "title",      null: false
    t.text     "body",       null: false
    t.integer  "user_id",    null: false
    t.string   "slug",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dotfiles", ["slug"], name: "index_dotfiles_on_slug", unique: true, using: :btree
  add_index "dotfiles", ["title"], name: "index_dotfiles_on_title", using: :btree

  create_table "hacks", force: true do |t|
    t.string   "title",                  null: false
    t.text     "body",                   null: false
    t.integer  "user_id",                null: false
    t.string   "slug",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "popularity", default: 0
  end

  add_index "hacks", ["slug"], name: "index_hacks_on_slug", unique: true, using: :btree
  add_index "hacks", ["title"], name: "index_hacks_on_title", using: :btree

  create_table "plugins", force: true do |t|
    t.string   "title",                   null: false
    t.string   "description",             null: false
    t.string   "link",                    null: false
    t.integer  "user_id",                 null: false
    t.string   "slug",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "popularity",  default: 0
  end

  add_index "plugins", ["slug"], name: "index_plugins_on_slug", unique: true, using: :btree
  add_index "plugins", ["title"], name: "index_plugins_on_title", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title",                   null: false
    t.string   "body",                    null: false
    t.integer  "user_id",                 null: false
    t.string   "post_img",   default: ""
    t.string   "slug",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["title"], name: "index_posts_on_title", using: :btree

  create_table "spectators", force: true do |t|
    t.integer  "user_id"
    t.string   "s_model"
    t.string   "s_action"
    t.integer  "s_record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",               default: "",    null: false
    t.string   "encrypted_password",  default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",               default: false
    t.string   "slug",                                null: false
    t.string   "nickname",                            null: false
    t.string   "user_img",            default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_code",         default: 1
    t.integer  "plugin_id",           default: [],                 array: true
    t.integer  "hack_id",             default: [],                 array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
