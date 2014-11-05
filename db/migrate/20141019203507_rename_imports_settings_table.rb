class RenameImportsSettingsTable < ActiveRecord::Migration
  def up
    rename_table :imports_settings, :import_settings
    rename_table :language_imports_settings, :language_import_settings
    rename_table :references_types, :reference_types
    rename_table :roles_users, :role_users
  end

  def down
    rename_table :import_settings, :imports_settings
    rename_table :language_import_settings, :language_imports_settings
    rename_table :reference_types, :references_types
    rename_table :role_users, :roles_users
  end
end
