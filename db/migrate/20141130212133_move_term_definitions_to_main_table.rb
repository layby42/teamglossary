class MoveTermDefinitionsToMainTable < ActiveRecord::Migration
  def up
    add_column :glossary_terms, :definition, :text
    add_column :glossary_terms, :is_definition_private, :boolean, null: false, default: false
    execute(%q{
      UPDATE glossary_terms SET definition = glossary_term_definitions.definition, is_definition_private = glossary_term_definitions.is_private
      FROM glossary_term_definitions
      WHERE glossary_terms.id = glossary_term_definitions.glossary_term_id;
      })

    add_column :glossary_term_translations, :definition, :text
    execute(%q{
      UPDATE glossary_term_translations SET definition = glossary_term_definition_translations.definition
      FROM glossary_term_definition_translations
      WHERE glossary_term_translations.language_id = glossary_term_definition_translations.language_id
        AND EXISTS( SELECT glossary_term_definitions.id
                    FROM glossary_term_definitions
                    WHERE glossary_term_definitions.glossary_term_id = glossary_term_translations.glossary_term_id
                      AND glossary_term_definitions.id = glossary_term_definition_translations.glossary_term_definition_id);
      })
  end

  def down
    remove_column :glossary_terms, :definition
    remove_column :glossary_terms, :is_definition_private

    remove_column :glossary_term_translations, :definition
  end
end
