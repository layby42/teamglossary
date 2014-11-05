class RenameRoleUsers < ActiveRecord::Migration
  def up
    rename_table :role_users, :language_users
    add_column :language_users, :id, :primary_key
    add_column :language_users, :language_id, :integer
    add_column :language_users, :role, :string

    execute(%Q{
      UPDATE language_users SET
        language_id = (SELECT authorizable_id FROM roles WHERE roles.id = language_users.role_id);
      })

    execute(%Q{
      UPDATE language_users SET
        role = (SELECT name FROM roles WHERE roles.id = language_users.role_id);
      })

    change_column :language_users, :role, :string, null: false

    add_index :language_users, [:user_id, :role, :language_id], unique: true, using: :btree
    add_foreign_key :language_users, :users, dependent: :destroy
    add_foreign_key :language_users, :languages, dependent: :destroy
  end

  def down
    remove_column :language_users, :id
    remove_column :language_users, :language_id
    remove_column :language_users, :role
    rename_table :language_users, :role_users
  end
end
