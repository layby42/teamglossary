class RemoveArabitFromTerms < ActiveRecord::Migration
  def up
    remove_column :glossary_terms, :arabic
    remove_column :import_glossary_terms, :arabic
  end

  def down
    add_column :glossary_terms, :arabic, :string
    add_column :import_glossary_terms, :arabic, :string
  end
end
