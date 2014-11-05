class RemoveRoleTable < ActiveRecord::Migration
  def up
    remove_column :language_users, :role_id
    drop_table :roles
  end

  def down
    add_column :language_users, :role_id
    create_table :roles
  end
end
