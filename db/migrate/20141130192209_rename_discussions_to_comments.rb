class RenameDiscussionsToComments < ActiveRecord::Migration
  def up
    rename_table :discussions, :comments
    rename_column :comments, :discussible_id, :commentable_id
    rename_column :comments, :discussible_type, :commentable_type
  end

  def down
    rename_table :comments, :discussions
    rename_column :discussions, :commentable_id, :discussible_id
    rename_column :discussions, :commentable_type, :discussible_type
  end
end
