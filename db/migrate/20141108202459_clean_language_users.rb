class CleanLanguageUsers < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, null: false, default: false

    admin_user_ids = LanguageUser.where(role: :admin).pluck(:user_id)
    User.where(id: admin_user_ids).each do |user|
      user.update_attributes!(admin: true)
    end
  end

  def down
    remove_column :users, :admin
  end
end
