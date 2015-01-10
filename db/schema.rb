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

ActiveRecord::Schema.define(version: 20150110201721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.integer  "language_id"
    t.integer  "user_id"
    t.string   "commentable_type"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "language_id", "commentable_id", "user_id"], name: "discussions_discussible_type_language_discussible_user", using: :btree
  add_index "comments", ["user_id", "commentable_type", "language_id", "commentable_id"], name: "discussions_user_discussible_type_language_discussible", using: :btree

  create_table "general_menu_actions", force: true do |t|
    t.integer  "language_id",     null: false
    t.integer  "general_menu_id", null: false
    t.string   "action"
    t.string   "name"
    t.date     "start_date",      null: false
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "task_id",         null: false
  end

  add_index "general_menu_actions", ["general_menu_id", "language_id", "action"], name: "general_menu_actions_menu_language_action", using: :btree

  create_table "general_menu_translations", force: true do |t|
    t.integer  "language_id"
    t.integer  "general_menu_id"
    t.string   "name",                limit: 500,                 null: false
    t.date     "online"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "additional_text"
    t.date     "cms_updated"
    t.boolean  "synchronized",                    default: false, null: false
    t.datetime "updated_from_cms_at"
  end

  add_index "general_menu_translations", ["general_menu_id", "language_id"], name: "general_menu_translations_menu_item_language", unique: true, using: :btree

  create_table "general_menus", force: true do |t|
    t.integer  "general_menu_id"
    t.string   "cms_name",                                        null: false
    t.string   "name",                limit: 500,                 null: false
    t.integer  "sequence",                                        null: false
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type",                       default: "F",   null: false
    t.integer  "language_id",                     default: 3,     null: false
    t.boolean  "synchronized",                    default: false, null: false
    t.string   "length_type"
    t.text     "additional_text"
    t.date     "cms_updated"
    t.string   "wiki_qa"
    t.string   "full_cms_path"
    t.date     "online"
    t.datetime "updated_from_cms_at"
    t.integer  "level",                           default: 0,     null: false
  end

  add_index "general_menus", ["general_menu_id", "sequence", "name"], name: "index_general_menus_on_general_menu_id_and_sequence_and_name", using: :btree
  add_index "general_menus", ["language_id", "general_menu_id", "cms_name"], name: "general_menus_language_parent_cms_name", unique: true, using: :btree

  create_table "general_statuses", force: true do |t|
    t.string   "code",                        null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "is_default",  default: false, null: false
    t.boolean  "is_private",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "general_statuses", ["code"], name: "index_general_statuses_on_code", unique: true, using: :btree
  add_index "general_statuses", ["is_default"], name: "index_general_statuses_on_is_default", using: :btree
  add_index "general_statuses", ["is_private"], name: "index_general_statuses_on_is_private", using: :btree

  create_table "glossary_name_translations", force: true do |t|
    t.integer  "language_id",           null: false
    t.integer  "glossary_name_id",      null: false
    t.integer  "integration_status_id", null: false
    t.string   "term",                  null: false
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "alt_term3"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glossary_name_translations", ["glossary_name_id"], name: "index_glossary_name_translations_on_glossary_name_id", using: :btree
  add_index "glossary_name_translations", ["language_id", "glossary_name_id"], name: "glossary_name_translations_language_glossary_name", unique: true, using: :btree

  create_table "glossary_names", force: true do |t|
    t.integer  "language_id",                           null: false
    t.integer  "proper_name_type_id",                   null: false
    t.integer  "integration_status_id",                 null: false
    t.string   "term",                                  null: false
    t.string   "tibetan"
    t.string   "sanskrit"
    t.text     "explanation"
    t.boolean  "is_private",            default: false, null: false
    t.boolean  "deleted",               default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dates"
    t.text     "rejected_because"
  end

  add_index "glossary_names", ["language_id", "integration_status_id"], name: "index_glossary_names_on_language_id_and_integration_status_id", using: :btree
  add_index "glossary_names", ["language_id", "proper_name_type_id", "term"], name: "index_glossary_names_language_type_name", unique: true, using: :btree

  create_table "glossary_term_definition_translations", force: true do |t|
    t.integer  "language_id",                 null: false
    t.integer  "glossary_term_definition_id", null: false
    t.text     "definition",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glossary_term_definition_translations", ["language_id", "glossary_term_definition_id"], name: "glossary_term_definition_translations_unique", unique: true, using: :btree

  create_table "glossary_term_definitions", force: true do |t|
    t.integer  "glossary_term_id"
    t.text     "definition",                       null: false
    t.boolean  "is_private",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glossary_term_definitions", ["glossary_term_id"], name: "index_glossary_term_definitions_on_glossary_term_id", using: :btree

  create_table "glossary_term_translations", force: true do |t|
    t.integer  "language_id",           null: false
    t.integer  "glossary_term_id",      null: false
    t.integer  "integration_status_id", null: false
    t.string   "term",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "alt_term3"
    t.text     "notes"
    t.string   "term_gender"
    t.text     "definition"
  end

  add_index "glossary_term_translations", ["glossary_term_id"], name: "index_glossary_term_translations_on_glossary_term_id", using: :btree
  add_index "glossary_term_translations", ["language_id", "glossary_term_id"], name: "glossary_term_translations_language_glossary_term", unique: true, using: :btree

  create_table "glossary_terms", force: true do |t|
    t.integer  "language_id",                            null: false
    t.integer  "reference_type_id",                      null: false
    t.integer  "general_status_id",                      null: false
    t.integer  "integration_status_id",                  null: false
    t.integer  "glossary_term_id"
    t.string   "term",                                   null: false
    t.string   "tibetan"
    t.string   "sanskrit"
    t.string   "pali"
    t.boolean  "is_private",             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",                default: false
    t.integer  "sanskrit_status_id",                     null: false
    t.string   "alternative_tibetan"
    t.string   "alternative_sanskrit"
    t.text     "additional_explanation"
    t.string   "sanskrit_gender"
    t.string   "pali_gender"
    t.text     "definition"
    t.boolean  "is_definition_private",  default: false, null: false
    t.text     "rejected_because"
  end

  add_index "glossary_terms", ["glossary_term_id", "id"], name: "index_glossary_terms_on_glossary_term_id_and_id", using: :btree
  add_index "glossary_terms", ["language_id", "general_status_id"], name: "index_glossary_terms_on_language_id_and_general_status_id", using: :btree
  add_index "glossary_terms", ["language_id", "integration_status_id"], name: "index_glossary_terms_on_language_id_and_integration_status_id", using: :btree
  add_index "glossary_terms", ["language_id", "reference_type_id"], name: "index_glossary_terms_on_language_id_and_reference_type_id", using: :btree
  add_index "glossary_terms", ["language_id", "term"], name: "index_glossary_terms_on_language_id_and_term", unique: true, using: :btree

  create_table "glossary_title_translations", force: true do |t|
    t.integer  "language_id",           null: false
    t.integer  "glossary_title_id",     null: false
    t.integer  "integration_status_id", null: false
    t.string   "term",                  null: false
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "alt_term3"
    t.string   "author"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "glossary_title_translations", ["glossary_title_id"], name: "index_glossary_title_translations_on_glossary_title_id", using: :btree
  add_index "glossary_title_translations", ["language_id", "glossary_title_id"], name: "glossary_title_translations_language_glossary_title", unique: true, using: :btree

  create_table "glossary_titles", force: true do |t|
    t.integer  "language_id",                            null: false
    t.integer  "integration_status_id",                  null: false
    t.string   "term",                                   null: false
    t.string   "author"
    t.string   "tibetan_full"
    t.string   "tibetan_short"
    t.string   "sanskrit_full"
    t.string   "sanskrit_short"
    t.string   "sanskrit_full_diacrit"
    t.string   "sanskrit_short_diacrit"
    t.text     "explanation"
    t.boolean  "is_private",             default: false, null: false
    t.boolean  "deleted",                default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_translit"
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "popular_term"
    t.string   "pali"
    t.text     "rejected_because"
  end

  add_index "glossary_titles", ["language_id", "integration_status_id"], name: "index_glossary_titles_on_language_id_and_integration_status_id", using: :btree
  add_index "glossary_titles", ["language_id", "term"], name: "glossary_titles_language_term", unique: true, using: :btree

  create_table "glossary_types", force: true do |t|
    t.string   "code",                    null: false
    t.string   "name",                    null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model_name",              null: false
    t.integer  "sorting",     default: 0, null: false
  end

  add_index "glossary_types", ["code"], name: "index_glossary_types_on_code", unique: true, using: :btree

  create_table "import_glossary_names", force: true do |t|
    t.integer  "import_id",                         null: false
    t.integer  "proper_name_type_id",               null: false
    t.integer  "integration_status_id",             null: false
    t.integer  "glossary_name_id"
    t.integer  "translation_integration_status_id"
    t.string   "term",                              null: false
    t.string   "tibetan"
    t.string   "sanskrit"
    t.string   "dates"
    t.string   "term_created_at"
    t.string   "term_updated_at"
    t.string   "term_translation"
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "alt_term3"
    t.string   "term_translation_created_at"
    t.string   "term_translation_updated_at"
    t.text     "explanation"
    t.text     "notes"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_glossary_names", ["import_id", "term"], name: "index_import_glossary_names_on_import_id_and_term", using: :btree
  add_index "import_glossary_names", ["import_id"], name: "index_import_glossary_names_on_import_id", using: :btree

  create_table "import_glossary_terms", force: true do |t|
    t.integer  "import_id",                         null: false
    t.integer  "reference_type_id",                 null: false
    t.integer  "general_status_id",                 null: false
    t.integer  "sanskrit_status_id",                null: false
    t.integer  "integration_status_id",             null: false
    t.integer  "glossary_term_id"
    t.integer  "glossary_main_term_id"
    t.integer  "translation_integration_status_id"
    t.string   "term",                              null: false
    t.string   "tibetan"
    t.string   "sanskrit"
    t.string   "pali"
    t.string   "term_created_at"
    t.string   "term_updated_at"
    t.text     "definition"
    t.string   "definition_created_at"
    t.string   "definition_updated_at"
    t.string   "term_translation"
    t.string   "term_translation_created_at"
    t.string   "term_translation_updated_at"
    t.text     "definition_translation"
    t.string   "definition_translation_created_at"
    t.string   "definition_translation_updated_at"
    t.text     "additional_explanation"
    t.text     "notes"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alternative_tibetan"
    t.string   "alternative_sanskrit"
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "alt_term3"
  end

  add_index "import_glossary_terms", ["import_id", "term"], name: "index_import_glossary_terms_on_import_id_and_term", using: :btree
  add_index "import_glossary_terms", ["import_id"], name: "index_import_glossary_terms_on_import_id", using: :btree

  create_table "import_glossary_titles", force: true do |t|
    t.integer  "import_id",                         null: false
    t.integer  "integration_status_id",             null: false
    t.integer  "glossary_title_id"
    t.integer  "translation_integration_status_id"
    t.string   "term",                              null: false
    t.string   "term_created_at"
    t.string   "term_updated_at"
    t.string   "author"
    t.string   "author_translit"
    t.string   "tibetan_full"
    t.string   "tibetan_short"
    t.string   "sanskrit_full"
    t.string   "sanskrit_short"
    t.string   "sanskrit_full_diacrit"
    t.string   "sanskrit_short_diacrit"
    t.string   "pali"
    t.string   "alt_term1"
    t.string   "alt_term2"
    t.string   "popular_term"
    t.string   "explanation"
    t.string   "term_translation"
    t.string   "term_translation_created_at"
    t.string   "term_translation_updated_at"
    t.string   "alt_term1_translation"
    t.string   "alt_term2_translation"
    t.string   "alt_term3_translation"
    t.string   "author_translation"
    t.string   "notes"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_glossary_titles", ["import_id", "term"], name: "index_import_glossary_titles_on_import_id_and_term", using: :btree
  add_index "import_glossary_titles", ["import_id"], name: "index_import_glossary_titles_on_import_id", using: :btree

  create_table "import_settings", force: true do |t|
    t.integer  "glossary_type_id",                 null: false
    t.integer  "csv_column",                       null: false
    t.string   "name",                             null: false
    t.text     "description",                      null: false
    t.string   "default",                          null: false
    t.boolean  "is_base",          default: false, null: false
    t.boolean  "is_required",      default: false, null: false
    t.string   "type_of_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "column_name",      default: "log"
  end

  add_index "import_settings", ["glossary_type_id", "csv_column"], name: "index_import_settings_on_glossary_type_id_and_csv_column", unique: true, using: :btree

  create_table "imports", force: true do |t|
    t.integer  "glossary_type_id",               null: false
    t.integer  "language_id",                    null: false
    t.integer  "user_id"
    t.string   "file",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "skip_rows",        default: 0
    t.string   "cols_separator",   default: ","
    t.text     "note"
    t.text     "log"
    t.integer  "committer_id"
    t.datetime "committed_at"
    t.string   "encoding"
    t.text     "data"
    t.string   "date_format"
    t.integer  "condition_column"
    t.integer  "condition_option"
    t.string   "condition_text"
  end

  add_index "imports", ["glossary_type_id"], name: "index_imports_on_glossary_type_id", using: :btree
  add_index "imports", ["language_id"], name: "index_imports_on_language_id", using: :btree
  add_index "imports", ["user_id"], name: "index_imports_on_user_id", using: :btree

  create_table "integration_statuses", force: true do |t|
    t.string   "code",                        null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "is_default",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "integration_statuses", ["code"], name: "index_integration_statuses_on_code", unique: true, using: :btree
  add_index "integration_statuses", ["is_default"], name: "index_integration_statuses_on_is_default", using: :btree

  create_table "language_import_settings", force: true do |t|
    t.integer  "language_id",                       null: false
    t.integer  "import_setting_id",                 null: false
    t.integer  "csv_column",        default: -1,    null: false
    t.boolean  "do_not_import",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "language_import_settings", ["import_setting_id", "language_id", "csv_column"], name: "language_imports_settings_unique", using: :btree
  add_index "language_import_settings", ["import_setting_id"], name: "index_language_import_settings_on_import_setting_id", using: :btree
  add_index "language_import_settings", ["language_id"], name: "index_language_import_settings_on_language_id", using: :btree

  create_table "language_users", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level",       default: 0, null: false
    t.integer  "language_id"
    t.string   "role",                    null: false
  end

  add_index "language_users", ["user_id", "role", "language_id"], name: "index_language_users_on_user_id_and_role_and_language_id", unique: true, using: :btree
  add_index "language_users", ["user_id"], name: "index_language_users_on_user_id", using: :btree

  create_table "languages", force: true do |t|
    t.string   "iso_code",         limit: 10,                     null: false
    t.string   "english_name",     limit: 100,                    null: false
    t.string   "name",             limit: 100,                    null: false
    t.boolean  "is_base_language",              default: false
    t.boolean  "is_active",                     default: true,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encoding",         limit: 15,   default: "UTF-8", null: false
    t.string   "notes",            limit: 4000
  end

  add_index "languages", ["iso_code", "name"], name: "index_languages_on_iso_code_and_name", unique: true, using: :btree
  add_index "languages", ["iso_code"], name: "index_languages_on_iso_code", unique: true, using: :btree

  create_table "online_statuses", force: true do |t|
    t.string   "code",                        null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "is_default",  default: false, null: false
    t.boolean  "is_system",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "online_statuses", ["code"], name: "index_online_statuses_on_code", unique: true, using: :btree
  add_index "online_statuses", ["is_default"], name: "index_online_statuses_on_is_default", using: :btree

  create_table "proper_name_types", force: true do |t|
    t.string   "code",        limit: 3,                    null: false
    t.string   "name",        limit: 100,                  null: false
    t.string   "description", limit: 2000
    t.boolean  "is_default",               default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proper_name_types", ["code"], name: "index_proper_name_types_on_code", unique: true, using: :btree
  add_index "proper_name_types", ["is_default"], name: "index_proper_name_types_on_is_default", using: :btree

  create_table "reference_types", force: true do |t|
    t.string   "code",                        null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "is_default",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reference_types", ["code"], name: "index_reference_types_on_code", unique: true, using: :btree
  add_index "reference_types", ["is_default"], name: "index_reference_types_on_is_default", using: :btree

  create_table "sanskrit_statuses", force: true do |t|
    t.string   "code",                        null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.boolean  "is_default",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sanskrit_statuses", ["code"], name: "index_sanskrit_statuses_on_code", unique: true, using: :btree
  add_index "sanskrit_statuses", ["is_default"], name: "index_sanskrit_statuses_on_is_default", using: :btree

  create_table "settings", force: true do |t|
    t.integer "configurable_id",               null: false
    t.string  "configurable_type",             null: false
    t.string  "name",              limit: 250, null: false
    t.text    "value"
  end

  add_index "settings", ["configurable_id", "configurable_type", "name"], name: "configurable_index", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.string   "title",                      null: false
    t.boolean  "article",    default: false, null: false
    t.boolean  "audio",      default: false, null: false
    t.boolean  "video",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["title"], name: "index_tasks_on_title", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                               null: false
    t.string   "first_name",                          null: false
    t.string   "last_name"
    t.string   "crypted_password",                    null: false
    t.string   "password_salt",                       null: false
    t.string   "email",                               null: false
    t.datetime "last_login"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token",                   null: false
    t.string   "single_access_token",                 null: false
    t.string   "perishable_token",                    null: false
    t.integer  "login_count",         default: 0,     null: false
    t.integer  "failed_login_count",  default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",               default: false, null: false
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "wish_lists", force: true do |t|
    t.integer  "user_id"
    t.string   "subject",     null: false
    t.text     "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wish_lists", ["subject"], name: "index_wish_lists_on_subject", unique: true, using: :btree
  add_index "wish_lists", ["user_id"], name: "index_wish_lists_on_user_id", using: :btree

  add_foreign_key "comments", "languages", name: "fk_discussions_languages", dependent: :restrict
  add_foreign_key "comments", "users", name: "fk_discussions_users", dependent: :restrict

  add_foreign_key "general_menu_actions", "general_menus", name: "fk_general_menu_actions_general_menus", dependent: :restrict
  add_foreign_key "general_menu_actions", "languages", name: "fk_general_menu_actions_languages", dependent: :restrict
  add_foreign_key "general_menu_actions", "tasks", name: "general_menu_actions_task_id_fk"
  add_foreign_key "general_menu_actions", "users", name: "fk_general_menu_actions_users", dependent: :restrict

  add_foreign_key "general_menu_translations", "general_menus", name: "fk_general_menu_translations_general_menus", dependent: :restrict
  add_foreign_key "general_menu_translations", "languages", name: "fk_general_menu_translations_languages", dependent: :restrict

  add_foreign_key "general_menus", "general_menus", name: "fk_general_menus_general_menus", dependent: :restrict
  add_foreign_key "general_menus", "languages", name: "fk_general_menus_languages", dependent: :restrict

  add_foreign_key "glossary_name_translations", "glossary_names", name: "fk_glossary_name_translations_glossary_names", dependent: :restrict
  add_foreign_key "glossary_name_translations", "integration_statuses", name: "fk_glossary_name_translations_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_name_translations", "languages", name: "fk_glossary_name_translations_languages", dependent: :restrict

  add_foreign_key "glossary_names", "integration_statuses", name: "fk_glossary_names_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_names", "languages", name: "fk_glossary_names_languages", dependent: :restrict

  add_foreign_key "glossary_term_definition_translations", "glossary_term_definitions", name: "fk_glossary_term_definition_translations_glossary_term_definiti", dependent: :restrict
  add_foreign_key "glossary_term_definition_translations", "languages", name: "fk_glossary_term_definition_translations_languages", dependent: :restrict

  add_foreign_key "glossary_term_definitions", "glossary_terms", name: "fk_glossary_term_definitions_glossary_terms", dependent: :restrict

  add_foreign_key "glossary_term_translations", "glossary_terms", name: "fk_glossary_term_translations_glossary_terms", dependent: :restrict
  add_foreign_key "glossary_term_translations", "integration_statuses", name: "fk_glossary_term_translations_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_term_translations", "languages", name: "fk_glossary_term_translations_languages", dependent: :restrict

  add_foreign_key "glossary_terms", "general_statuses", name: "fk_glossary_terms_general_statuses", dependent: :restrict
  add_foreign_key "glossary_terms", "glossary_terms", name: "fk_glossary_terms_glossary_terms", dependent: :restrict
  add_foreign_key "glossary_terms", "integration_statuses", name: "fk_glossary_terms_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_terms", "languages", name: "fk_glossary_terms_languages", dependent: :restrict
  add_foreign_key "glossary_terms", "reference_types", name: "fk_glossary_terms_references_types", dependent: :restrict
  add_foreign_key "glossary_terms", "sanskrit_statuses", name: "fk_glossary_terms_sanskrit_statuses", dependent: :restrict

  add_foreign_key "glossary_title_translations", "glossary_titles", name: "fk_glossary_title_translations_glossary_titles", dependent: :restrict
  add_foreign_key "glossary_title_translations", "integration_statuses", name: "fk_glossary_title_translations_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_title_translations", "languages", name: "fk_glossary_title_translations_languages", dependent: :restrict

  add_foreign_key "glossary_titles", "integration_statuses", name: "fk_glossary_titles_integration_statuses", dependent: :restrict
  add_foreign_key "glossary_titles", "languages", name: "fk_glossary_titles_languages", dependent: :restrict

  add_foreign_key "import_glossary_names", "glossary_names", name: "fk_import_glossary_names_glossary_names", dependent: :restrict
  add_foreign_key "import_glossary_names", "imports", name: "fk_import_glossary_names_imports", dependent: :restrict
  add_foreign_key "import_glossary_names", "integration_statuses", name: "fk_import_glossary_names_integration_statuses", dependent: :restrict
  add_foreign_key "import_glossary_names", "integration_statuses", name: "fk_import_glossary_names_translation_integration_statuses", column: "translation_integration_status_id", dependent: :restrict

  add_foreign_key "import_glossary_terms", "general_statuses", name: "fk_import_glossary_terms_general_statuses", dependent: :restrict
  add_foreign_key "import_glossary_terms", "glossary_terms", name: "fk_import_glossary_terms_glossary_main_terms", column: "glossary_main_term_id", dependent: :restrict
  add_foreign_key "import_glossary_terms", "glossary_terms", name: "fk_import_glossary_terms_glossary_terms", dependent: :restrict
  add_foreign_key "import_glossary_terms", "imports", name: "fk_import_glossary_terms_imports", dependent: :restrict
  add_foreign_key "import_glossary_terms", "integration_statuses", name: "fk_import_glossary_terms_integration_statuses", dependent: :restrict
  add_foreign_key "import_glossary_terms", "integration_statuses", name: "fk_import_glossary_terms_translation_integration_statuses", column: "translation_integration_status_id", dependent: :restrict
  add_foreign_key "import_glossary_terms", "reference_types", name: "fk_import_glossary_terms_references_types", dependent: :restrict
  add_foreign_key "import_glossary_terms", "sanskrit_statuses", name: "fk_import_glossary_terms_sanskrit_statuses", dependent: :restrict

  add_foreign_key "import_glossary_titles", "glossary_titles", name: "fk_import_glossary_titles_glossary_titles", dependent: :restrict
  add_foreign_key "import_glossary_titles", "imports", name: "fk_import_glossary_titles_imports", dependent: :restrict
  add_foreign_key "import_glossary_titles", "integration_statuses", name: "fk_import_glossary_titles_integration_statuses", dependent: :restrict
  add_foreign_key "import_glossary_titles", "integration_statuses", name: "fk_import_glossary_titles_translation_integration_statuses", column: "translation_integration_status_id", dependent: :restrict

  add_foreign_key "import_settings", "glossary_types", name: "fk_imports_settings_glossary_types", dependent: :restrict

  add_foreign_key "imports", "glossary_types", name: "fk_imports_imports_glossary_types", dependent: :restrict
  add_foreign_key "imports", "languages", name: "fk_imports_languages", dependent: :restrict
  add_foreign_key "imports", "users", name: "fk_imports_imports_committed_users", column: "committer_id", dependent: :restrict
  add_foreign_key "imports", "users", name: "fk_imports_imports_users", dependent: :restrict

  add_foreign_key "language_import_settings", "import_settings", name: "fk_language_imports_settings_imports_settings", dependent: :restrict
  add_foreign_key "language_import_settings", "languages", name: "fk_language_imports_settings_languages", dependent: :restrict

  add_foreign_key "language_users", "languages", name: "language_users_language_id_fk"
  add_foreign_key "language_users", "users", name: "fk_roles_users_users", dependent: :restrict
  add_foreign_key "language_users", "users", name: "language_users_user_id_fk"

  add_foreign_key "wish_lists", "users", name: "fk_wish_lists_users", dependent: :restrict

end
