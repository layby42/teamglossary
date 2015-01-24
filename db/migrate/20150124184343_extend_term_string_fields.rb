class ExtendTermStringFields < ActiveRecord::Migration
  def up
    change_column :glossary_terms, :term, :string, null: false, limit: 1000
    change_column :glossary_term_translations, :term, :string, null: false, limit: 1000
    change_column :glossary_term_translations, :alt_term1, :string, null: true, limit: 1000
    change_column :glossary_term_translations, :alt_term2, :string, null: true, limit: 1000
    change_column :glossary_term_translations, :alt_term3, :string, null: true, limit: 1000

    change_column :glossary_names, :term, :string, null: false, limit: 1000
    change_column :glossary_name_translations, :term, :string, null: false, limit: 1000
    change_column :glossary_name_translations, :alt_term1, :string, null: true, limit: 1000
    change_column :glossary_name_translations, :alt_term2, :string, null: true, limit: 1000
    change_column :glossary_name_translations, :alt_term3, :string, null: true, limit: 1000

    change_column :glossary_titles, :term, :string, null: false, limit: 1000
    change_column :glossary_titles, :popular_term, :string, null: true, limit: 1000
    change_column :glossary_titles, :alt_term1, :string, null: true, limit: 1000
    change_column :glossary_titles, :alt_term2, :string, null: true, limit: 1000
    change_column :glossary_title_translations, :term, :string, null: false, limit: 1000
    change_column :glossary_title_translations, :alt_term1, :string, null: true, limit: 1000
    change_column :glossary_title_translations, :alt_term2, :string, null: true, limit: 1000
    change_column :glossary_title_translations, :alt_term3, :string, null: true, limit: 1000

    change_column :general_menus, :name, :string, null: false, limit: 1000
    change_column :general_menu_translations, :name, :string, null: false, limit: 1000

  end

  def down
  end
end
