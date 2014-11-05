class RenameFields < ActiveRecord::Migration
  def up
    rename_column :language_import_settings, :imports_setting_id, :import_setting_id
    rename_column :glossary_terms, :references_type_id, :reference_type_id
    rename_column :import_glossary_terms, :references_type_id, :reference_type_id

  end

  def down
    rename_column :language_import_settings, :import_setting_id, :imports_setting_id
    rename_column :glossary_terms, :reference_type_id, :references_type_id
    rename_column :import_glossary_terms, :reference_type_id, :references_type_id
  end
end
