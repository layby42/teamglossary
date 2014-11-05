class Initial < ActiveRecord::Migration
  def change
  #   create_table "discussions", :force => true do |t|
  #     t.integer  "discussible_id"
  #     t.integer  "language_id"
  #     t.integer  "user_id"
  #     t.string   "discussible_type"
  #     t.text     "text"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "discussions", ["discussible_type", "language_id", "discussible_id", "user_id"], :name => "discussions_discussible_type_language_discussible_user"
  #   add_index "discussions", ["user_id", "discussible_type", "language_id", "discussible_id"], :name => "discussions_user_discussible_type_language_discussible"

  #   create_table "feeds", :force => true do |t|
  #     t.integer  "user_id"
  #     t.string   "name",                           :null => false
  #     t.string   "feed_url",                       :null => false
  #     t.integer  "max_items",       :default => 0, :null => false
  #     t.integer  "max_item_length", :default => 0, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "feeds", ["feed_url"], :name => "index_feeds_on_feed_url", :unique => true
  #   add_index "feeds", ["user_id"], :name => "index_feeds_on_user_id"

  #   create_table "general_menu_actions", :force => true do |t|
  #     t.integer  "language_id"
  #     t.integer  "general_menu_id"
  #     t.string   "action"
  #     t.string   "name"
  #     t.date     "start_date"
  #     t.date     "end_date"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.integer  "user_id"
  #   end

  #   add_index "general_menu_actions", ["general_menu_id", "language_id", "action"], :name => "general_menu_actions_menu_language_action"

  #   create_table "general_menu_siblings", :force => true do |t|
  #     t.integer  "general_menu_id"
  #     t.integer  "sibling_id",      :null => false
  #     t.integer  "sequence",        :null => false
  #     t.string   "name"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "full_cms_path"
  #   end

  #   add_index "general_menu_siblings", ["general_menu_id", "sibling_id"], :name => "index_general_menu_siblings_on_general_menu_id_and_main_id", :unique => true

  #   create_table "general_menu_translations", :force => true do |t|
  #     t.integer  "language_id"
  #     t.integer  "general_menu_id"
  #     t.string   "name",            :limit => 500,                    :null => false
  #     t.date     "online"
  #     t.text     "notes"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.text     "additional_text"
  #     t.date     "cms_updated"
  #     t.boolean  "synchronized",                   :default => false, :null => false
  #   end

  #   add_index "general_menu_translations", ["general_menu_id", "language_id"], :name => "general_menu_translations_menu_item_language", :unique => true

  #   create_table "general_menus", :force => true do |t|
  #     t.integer  "general_menu_id"
  #     t.string   "cms_name",                                          :null => false
  #     t.string   "name",            :limit => 500,                    :null => false
  #     t.integer  "sequence",                                          :null => false
  #     t.text     "remark"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "item_type",                      :default => "F",   :null => false
  #     t.integer  "language_id",                                       :null => false
  #     t.boolean  "synchronized",                   :default => false, :null => false
  #     t.string   "length_type"
  #     t.text     "additional_text"
  #     t.date     "cms_updated"
  #     t.string   "wiki_qa"
  #     t.string   "full_cms_path"
  #     t.date     "online"
  #   end

  #   add_index "general_menus", ["general_menu_id", "sequence", "name"], :name => "index_general_menus_on_general_menu_id_and_sequence_and_name"
  #   add_index "general_menus", ["language_id", "general_menu_id", "cms_name"], :name => "general_menus_language_parent_cms_name", :unique => true

  #   create_table "general_statuses", :force => true do |t|
  #     t.string   "code",                           :null => false
  #     t.string   "name",                           :null => false
  #     t.text     "description"
  #     t.boolean  "is_default",  :default => false, :null => false
  #     t.boolean  "is_private",  :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "general_statuses", ["code"], :name => "index_general_statuses_on_code", :unique => true
  #   add_index "general_statuses", ["is_default"], :name => "index_general_statuses_on_is_default"
  #   add_index "general_statuses", ["is_private"], :name => "index_general_statuses_on_is_private"

  #   create_table "glossary_name_translations", :force => true do |t|
  #     t.integer  "language_id",           :null => false
  #     t.integer  "glossary_name_id",      :null => false
  #     t.integer  "integration_status_id", :null => false
  #     t.string   "term",                  :null => false
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "alt_term3"
  #     t.text     "notes"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_name_translations", ["glossary_name_id"], :name => "index_glossary_name_translations_on_glossary_name_id"
  #   add_index "glossary_name_translations", ["language_id", "glossary_name_id"], :name => "glossary_name_translations_language_glossary_name", :unique => true

  #   create_table "glossary_names", :force => true do |t|
  #     t.integer  "language_id",                              :null => false
  #     t.integer  "proper_name_type_id",                      :null => false
  #     t.integer  "integration_status_id",                    :null => false
  #     t.string   "term",                                     :null => false
  #     t.string   "tibetan"
  #     t.string   "sanskrit"
  #     t.string   "wade_giles"
  #     t.string   "dates"
  #     t.text     "explanation"
  #     t.boolean  "is_private",            :default => false, :null => false
  #     t.boolean  "deleted",               :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_names", ["language_id", "integration_status_id"], :name => "index_glossary_names_on_language_id_and_integration_status_id"
  #   add_index "glossary_names", ["language_id", "proper_name_type_id", "term"], :name => "glossary_names_language_type_name", :unique => true

  #   create_table "glossary_term_definition_translations", :force => true do |t|
  #     t.integer  "language_id",                 :null => false
  #     t.integer  "glossary_term_definition_id", :null => false
  #     t.text     "definition",                  :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_term_definition_translations", ["language_id", "glossary_term_definition_id"], :name => "glossary_term_definition_translations_unique", :unique => true

  #   create_table "glossary_term_definitions", :force => true do |t|
  #     t.integer  "glossary_term_id"
  #     t.text     "definition",                          :null => false
  #     t.boolean  "is_private",       :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_term_definitions", ["glossary_term_id"], :name => "index_glossary_term_definitions_on_glossary_term_id"

  #   create_table "glossary_term_translations", :force => true do |t|
  #     t.integer  "language_id",           :null => false
  #     t.integer  "glossary_term_id",      :null => false
  #     t.integer  "integration_status_id", :null => false
  #     t.string   "term",                  :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "alt_term3"
  #     t.text     "notes"
  #     t.string   "term_gender"
  #   end

  #   add_index "glossary_term_translations", ["glossary_term_id"], :name => "index_glossary_term_translations_on_glossary_term_id"
  #   add_index "glossary_term_translations", ["language_id", "glossary_term_id"], :name => "glossary_term_translations_language_glossary_term", :unique => true

  #   create_table "glossary_terms", :force => true do |t|
  #     t.integer  "language_id",                               :null => false
  #     t.integer  "references_type_id",                        :null => false
  #     t.integer  "general_status_id",                         :null => false
  #     t.integer  "integration_status_id",                     :null => false
  #     t.integer  "glossary_term_id"
  #     t.string   "term",                                      :null => false
  #     t.string   "tibetan"
  #     t.string   "sanskrit"
  #     t.string   "pali"
  #     t.boolean  "is_private",             :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.boolean  "deleted",                :default => false
  #     t.string   "arabic"
  #     t.integer  "sanskrit_status_id",                        :null => false
  #     t.string   "alternative_tibetan"
  #     t.string   "alternative_sanskrit"
  #     t.text     "additional_explanation"
  #     t.string   "sanscrit_gender"
  #     t.string   "pali_gender"
  #   end

  #   add_index "glossary_terms", ["glossary_term_id", "id"], :name => "index_glossary_terms_on_glossary_term_id_and_id"
  #   add_index "glossary_terms", ["language_id", "general_status_id"], :name => "index_glossary_terms_on_language_id_and_general_status_id"
  #   add_index "glossary_terms", ["language_id", "integration_status_id"], :name => "index_glossary_terms_on_language_id_and_integration_status_id"
  #   add_index "glossary_terms", ["language_id", "references_type_id"], :name => "index_glossary_terms_on_language_id_and_references_type_id"
  #   add_index "glossary_terms", ["language_id", "term"], :name => "index_glossary_terms_on_language_id_and_term", :unique => true

  #   create_table "glossary_title_translations", :force => true do |t|
  #     t.integer  "language_id",           :null => false
  #     t.integer  "glossary_title_id",     :null => false
  #     t.integer  "integration_status_id", :null => false
  #     t.string   "term",                  :null => false
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "alt_term3"
  #     t.string   "author"
  #     t.text     "notes"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_title_translations", ["glossary_title_id"], :name => "index_glossary_title_translations_on_glossary_title_id"
  #   add_index "glossary_title_translations", ["language_id", "glossary_title_id"], :name => "glossary_title_translations_language_glossary_title", :unique => true

  #   create_table "glossary_titles", :force => true do |t|
  #     t.integer  "language_id",                               :null => false
  #     t.integer  "integration_status_id",                     :null => false
  #     t.string   "term",                                      :null => false
  #     t.string   "author"
  #     t.string   "tibetan_full"
  #     t.string   "tibetan_short"
  #     t.string   "sanskrit_full"
  #     t.string   "sanskrit_short"
  #     t.string   "sanskrit_full_diacrit"
  #     t.string   "sanskrit_short_diacrit"
  #     t.text     "explanation"
  #     t.boolean  "is_private",             :default => false, :null => false
  #     t.boolean  "deleted",                :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "author_translit"
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "popular_term"
  #     t.string   "pali"
  #   end

  #   add_index "glossary_titles", ["language_id", "integration_status_id"], :name => "index_glossary_titles_on_language_id_and_integration_status_id"
  #   add_index "glossary_titles", ["language_id", "term"], :name => "glossary_titles_language_term", :unique => true

  #   create_table "glossary_types", :force => true do |t|
  #     t.string   "code",        :null => false
  #     t.string   "name",        :null => false
  #     t.string   "description"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "glossary_types", ["code"], :name => "index_glossary_types_on_code", :unique => true

  #   create_table "import_glossary_names", :force => true do |t|
  #     t.integer  "import_id",                         :null => false
  #     t.integer  "proper_name_type_id",               :null => false
  #     t.integer  "integration_status_id",             :null => false
  #     t.integer  "glossary_name_id"
  #     t.integer  "translation_integration_status_id"
  #     t.string   "term",                              :null => false
  #     t.string   "tibetan"
  #     t.string   "sanskrit"
  #     t.string   "wade_giles"
  #     t.string   "dates"
  #     t.string   "term_created_at"
  #     t.string   "term_updated_at"
  #     t.string   "term_translation"
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "alt_term3"
  #     t.string   "term_translation_created_at"
  #     t.string   "term_translation_updated_at"
  #     t.text     "explanation"
  #     t.text     "notes"
  #     t.text     "log"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "import_glossary_names", ["import_id", "term"], :name => "index_import_glossary_names_on_import_id_and_term"
  #   add_index "import_glossary_names", ["import_id"], :name => "index_import_glossary_names_on_import_id"

  #   create_table "import_glossary_terms", :force => true do |t|
  #     t.integer  "import_id",                         :null => false
  #     t.integer  "references_type_id",                :null => false
  #     t.integer  "general_status_id",                 :null => false
  #     t.integer  "sanskrit_status_id",                :null => false
  #     t.integer  "integration_status_id",             :null => false
  #     t.integer  "glossary_term_id"
  #     t.integer  "glossary_main_term_id"
  #     t.integer  "translation_integration_status_id"
  #     t.string   "term",                              :null => false
  #     t.string   "tibetan"
  #     t.string   "sanskrit"
  #     t.string   "pali"
  #     t.string   "arabic"
  #     t.string   "term_created_at"
  #     t.string   "term_updated_at"
  #     t.text     "definition"
  #     t.string   "definition_created_at"
  #     t.string   "definition_updated_at"
  #     t.string   "term_translation"
  #     t.string   "term_translation_created_at"
  #     t.string   "term_translation_updated_at"
  #     t.text     "definition_translation"
  #     t.string   "definition_translation_created_at"
  #     t.string   "definition_translation_updated_at"
  #     t.text     "additional_explanation"
  #     t.text     "notes"
  #     t.text     "log"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "alternative_tibetan"
  #     t.string   "alternative_sanskrit"
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "alt_term3"
  #   end

  #   add_index "import_glossary_terms", ["import_id", "term"], :name => "index_import_glossary_terms_on_import_id_and_term"
  #   add_index "import_glossary_terms", ["import_id"], :name => "index_import_glossary_terms_on_import_id"

  #   create_table "import_glossary_titles", :force => true do |t|
  #     t.integer  "import_id",                         :null => false
  #     t.integer  "integration_status_id",             :null => false
  #     t.integer  "glossary_title_id"
  #     t.integer  "translation_integration_status_id"
  #     t.string   "term",                              :null => false
  #     t.string   "term_created_at"
  #     t.string   "term_updated_at"
  #     t.string   "author"
  #     t.string   "author_translit"
  #     t.string   "tibetan_full"
  #     t.string   "tibetan_short"
  #     t.string   "sanskrit_full"
  #     t.string   "sanskrit_short"
  #     t.string   "sanskrit_full_diacrit"
  #     t.string   "sanskrit_short_diacrit"
  #     t.string   "pali"
  #     t.string   "alt_term1"
  #     t.string   "alt_term2"
  #     t.string   "popular_term"
  #     t.string   "explanation"
  #     t.string   "term_translation"
  #     t.string   "term_translation_created_at"
  #     t.string   "term_translation_updated_at"
  #     t.string   "alt_term1_translation"
  #     t.string   "alt_term2_translation"
  #     t.string   "alt_term3_translation"
  #     t.string   "author_translation"
  #     t.string   "notes"
  #     t.text     "log"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "import_glossary_titles", ["import_id", "term"], :name => "index_import_glossary_titles_on_import_id_and_term"
  #   add_index "import_glossary_titles", ["import_id"], :name => "index_import_glossary_titles_on_import_id"

  #   create_table "imports", :force => true do |t|
  #     t.integer  "glossary_type_id",                  :null => false
  #     t.integer  "language_id",                       :null => false
  #     t.integer  "user_id"
  #     t.string   "file",                              :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.integer  "skip_rows",        :default => 0
  #     t.string   "cols_separator",   :default => ","
  #     t.text     "note"
  #     t.text     "log"
  #     t.integer  "committer_id"
  #     t.datetime "committed_at"
  #     t.string   "encoding"
  #     t.text     "data"
  #     t.string   "date_format"
  #     t.integer  "condition_column"
  #     t.integer  "condition_option"
  #     t.string   "condition_text"
  #   end

  #   add_index "imports", ["glossary_type_id"], :name => "index_imports_on_glossary_type_id"
  #   add_index "imports", ["language_id"], :name => "index_imports_on_language_id"
  #   add_index "imports", ["user_id"], :name => "index_imports_on_user_id"

  #   create_table "imports_settings", :force => true do |t|
  #     t.integer  "glossary_type_id",                    :null => false
  #     t.integer  "csv_column",                          :null => false
  #     t.string   "name",                                :null => false
  #     t.text     "description",                         :null => false
  #     t.string   "default",                             :null => false
  #     t.boolean  "is_base",          :default => false, :null => false
  #     t.boolean  "is_required",      :default => false, :null => false
  #     t.string   "type_of_data"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "column_name",      :default => "log"
  #   end

  #   add_index "imports_settings", ["glossary_type_id", "csv_column"], :name => "index_imports_settings_on_glossary_type_id_and_csv_column", :unique => true

  #   create_table "integration_statuses", :force => true do |t|
  #     t.string   "code",                           :null => false
  #     t.string   "name",                           :null => false
  #     t.text     "description"
  #     t.boolean  "is_default",  :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "integration_statuses", ["code"], :name => "index_integration_statuses_on_code", :unique => true
  #   add_index "integration_statuses", ["is_default"], :name => "index_integration_statuses_on_is_default"

  #   create_table "language_imports_settings", :force => true do |t|
  #     t.integer  "language_id",                           :null => false
  #     t.integer  "imports_setting_id",                    :null => false
  #     t.integer  "csv_column",         :default => -1,    :null => false
  #     t.boolean  "do_not_import",      :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "language_imports_settings", ["imports_setting_id", "language_id", "csv_column"], :name => "language_imports_settings_unique"
  #   add_index "language_imports_settings", ["imports_setting_id"], :name => "index_language_imports_settings_on_imports_setting_id"
  #   add_index "language_imports_settings", ["language_id"], :name => "index_language_imports_settings_on_language_id"

  #   create_table "languages", :force => true do |t|
  #     t.string   "iso_code",                                                   :null => false
  #     t.string   "english_name",                                               :null => false
  #     t.string   "name",                                                       :null => false
  #     t.boolean  "is_base_language",                 :default => false
  #     t.boolean  "is_active",                        :default => true,         :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "encoding",                         :default => "ISO-8859-1", :null => false
  #     t.string   "notes",            :limit => 4000
  #   end

  #   add_index "languages", ["iso_code", "name"], :name => "index_languages_on_iso_code_and_name", :unique => true
  #   add_index "languages", ["iso_code"], :name => "index_languages_on_iso_code", :unique => true

  #   create_table "proper_name_types", :force => true do |t|
  #     t.string   "code",                           :null => false
  #     t.string   "name",                           :null => false
  #     t.text     "description"
  #     t.boolean  "is_default",  :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "proper_name_types", ["code"], :name => "index_proper_name_types_on_code", :unique => true
  #   add_index "proper_name_types", ["is_default"], :name => "index_proper_name_types_on_is_default"

  #   create_table "references_types", :force => true do |t|
  #     t.string   "code",                           :null => false
  #     t.string   "name",                           :null => false
  #     t.text     "description"
  #     t.boolean  "is_default",  :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "references_types", ["code"], :name => "index_references_types_on_code", :unique => true
  #   add_index "references_types", ["is_default"], :name => "index_references_types_on_is_default"

  #   create_table "roles", :force => true do |t|
  #     t.string   "name",              :limit => 40
  #     t.string   "authorizable_type", :limit => 40
  #     t.integer  "authorizable_id"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "roles", ["authorizable_id"], :name => "index_roles_on_authorizable_id"
  #   add_index "roles", ["authorizable_type"], :name => "index_roles_on_authorizable_type"
  #   add_index "roles", ["name", "authorizable_id", "authorizable_type"], :name => "index_roles_on_name_and_authorizable_id_and_authorizable_type", :unique => true
  #   add_index "roles", ["name"], :name => "index_roles_on_name"

  #   create_table "roles_users", :id => false, :force => true do |t|
  #     t.integer  "user_id"
  #     t.integer  "role_id"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.integer  "level",      :default => 0, :null => false
  #   end

  #   add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  #   add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id", :unique => true
  #   add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  #   create_table "sanskrit_statuses", :force => true do |t|
  #     t.string   "code",                           :null => false
  #     t.string   "name",                           :null => false
  #     t.text     "description"
  #     t.boolean  "is_default",  :default => false, :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "sanskrit_statuses", ["code"], :name => "index_sanskrit_statuses_on_code", :unique => true
  #   add_index "sanskrit_statuses", ["is_default"], :name => "index_sanskrit_statuses_on_is_default"

  #   create_table "settings", :force => true do |t|
  #     t.integer "configurable_id"
  #     t.string  "configurable_type"
  #     t.string  "name",              :limit => 40, :null => false
  #     t.string  "value"
  #     t.string  "value_type"
  #   end

  #   add_index "settings", ["configurable_id", "configurable_type", "name"], :name => "configurable_index", :unique => true

  #   create_table "users", :force => true do |t|
  #     t.string   "login",         :null => false
  #     t.string   "first_name"
  #     t.string   "last_name"
  #     t.string   "password_hash", :null => false
  #     t.string   "password_salt", :null => false
  #     t.string   "email"
  #     t.datetime "last_login"
  #     t.text     "about"
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #     t.string   "remember_hash"
  #   end

  #   add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  #   create_table "users_feeds", :id => false, :force => true do |t|
  #     t.integer  "user_id",    :null => false
  #     t.integer  "feed_id",    :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "users_feeds", ["feed_id"], :name => "index_users_feeds_on_feed_id"
  #   add_index "users_feeds", ["user_id", "feed_id"], :name => "index_users_feeds_on_user_id_and_feed_id", :unique => true
  #   add_index "users_feeds", ["user_id"], :name => "index_users_feeds_on_user_id"

  #   create_table "wish_lists", :force => true do |t|
  #     t.integer  "user_id"
  #     t.string   "subject",     :null => false
  #     t.text     "description", :null => false
  #     t.datetime "created_at"
  #     t.datetime "updated_at"
  #   end

  #   add_index "wish_lists", ["subject"], :name => "index_wish_lists_on_subject", :unique => true
  #   add_index "wish_lists", ["user_id"], :name => "index_wish_lists_on_user_id"
  end
end
