class DeleteRememberHashFields < ActiveRecord::Migration
  def up
    remove_column :users, :remember_hash
  end

  def down
    add_column :users, :remember_hash, :string
  end
end
