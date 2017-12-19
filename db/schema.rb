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

ActiveRecord::Schema.define(version: 20171219120720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "activity_type", null: false
    t.string   "addable_type"
    t.integer  "addable_id"
    t.string   "actable_type",  null: false
    t.integer  "actable_id",    null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["actable_type", "actable_id"], name: "index_activities_on_actable_type_and_actable_id", using: :btree
    t.index ["activity_type", "user_id"], name: "index_activities_on_activity_type_and_user_id", using: :btree
    t.index ["user_id", "actable_id", "addable_id"], name: "index_activities_on_user_id_and_actable_id_and_addable_id", using: :btree
  end

  create_table "api_import_responses", force: :cascade do |t|
    t.text     "xml"
    t.jsonb    "json"
    t.text     "source_uri", null: false
    t.integer  "paper_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_api_import_responses_on_paper_id", using: :btree
  end

  create_table "authors", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "given_name"
    t.text     "family_name"
    t.citext   "full_name"
    t.index ["full_name"], name: "index_authors_on_full_name", unique: true, using: :btree
  end

  create_table "authors_papers", id: false, force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "paper_id",  null: false
    t.index ["author_id", "paper_id"], name: "index_authors_papers_on_author_id_and_paper_id", unique: true, using: :btree
  end

  create_table "comment_hierarchies", id: false, force: :cascade do |t|
    t.integer "generations",   null: false
    t.integer "ancestor_id"
    t.integer "descendant_id"
    t.index ["ancestor_id", "descendant_id"], name: "index_comment_hierarchies_on_ancestor_id_and_descendant_id", unique: true, using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "parent_id"
    t.integer  "cached_votes_up",  default: 0
    t.integer  "sort_order"
    t.index ["cached_votes_up"], name: "index_comments_on_cached_votes_up", using: :btree
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["parent_id"], name: "index_comments_on_parent_id", using: :btree
    t.index ["sort_order"], name: "index_comments_on_sort_order", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "homepages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id",    null: false
    t.index ["user_id"], name: "index_homepages_on_user_id", using: :btree
  end

  create_table "homepages_lists", id: false, force: :cascade do |t|
    t.integer "homepage_id", null: false
    t.integer "list_id",     null: false
    t.index ["homepage_id", "list_id"], name: "index_homepages_lists_on_homepage_id_and_list_id", unique: true, using: :btree
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
    t.index ["user_id"], name: "index_impressions_on_user_id", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.string   "url"
    t.integer  "paper_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "link_editable", default: true
    t.index ["url"], name: "index_links_on_url", using: :btree
  end

  create_table "list_memberships", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "list_id",                 null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "role",       default: 40, null: false
    t.index ["user_id", "list_id"], name: "index_list_memberships_on_user_id_and_list_id", unique: true, using: :btree
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "description"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "user_id",                        null: false
    t.string   "slug"
    t.integer  "visibility",        default: 30, null: false
    t.integer  "access",            default: 30, null: false
    t.integer  "impressions_count", default: 0
    t.index ["cached_votes_up", "created_at"], name: "index_lists_on_cached_votes_up_and_created_at", order: { cached_votes_up: :desc, created_at: :desc }, using: :btree
    t.index ["slug"], name: "index_lists_on_slug", using: :btree
    t.index ["user_id", "name"], name: "index_lists_on_user_id_and_name", using: :btree
    t.index ["user_id"], name: "index_lists_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.boolean  "has_read"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["activity_id"], name: "index_notifications_on_activity_id", using: :btree
  end

  create_table "papers", force: :cascade do |t|
    t.string   "title"
    t.date     "published_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "abstract"
    t.string   "doi"
    t.string   "pubmed_id"
    t.string   "publication"
    t.boolean  "abstract_editable",              default: true
    t.boolean  "paper_editable",                 default: true
    t.text     "import_source"
    t.integer  "referenced_by_count"
    t.datetime "referenced_by_count_updated_at"
    t.index ["doi"], name: "index_papers_on_doi", using: :btree
    t.index ["pubmed_id"], name: "index_papers_on_pubmed_id", using: :btree
  end

  create_table "references", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "cached_votes_up", default: 0
    t.integer  "list_id",                     null: false
    t.integer  "paper_id",                    null: false
    t.integer  "user_id"
    t.index ["cached_votes_up", "created_at"], name: "index_references_on_cached_votes_up_and_created_at", order: { cached_votes_up: :desc, created_at: :desc }, using: :btree
    t.index ["list_id", "paper_id"], name: "index_references_on_list_id_and_paper_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_references_on_user_id", using: :btree
  end

  create_table "summaries", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.integer  "list_id",                     null: false
    t.text     "content",                     null: false
    t.integer  "evidence_rating",             null: false
    t.integer  "comments",        default: 0
    t.integer  "cached_votes_up", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["cached_votes_up"], name: "index_summaries_on_cached_votes_up", using: :btree
    t.index ["list_id", "user_id", "evidence_rating"], name: "index_summaries_on_list_id_and_user_id_and_evidence_rating", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "about"
    t.string   "city"
    t.string   "country"
    t.string   "website"
    t.string   "first_name"
    t.string   "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id",   null: false
    t.string   "voter_type"
    t.integer  "voter_id",     null: false
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "api_import_responses", "papers"
  add_foreign_key "references", "users"
end
