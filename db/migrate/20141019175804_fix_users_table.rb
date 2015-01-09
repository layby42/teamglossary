class FixUsersTable < ActiveRecord::Migration
  def up
    rename_column :users, :password_hash, :crypted_password

    add_column :users, :persistence_token, :string
    add_column :users, :single_access_token, :string
    add_column :users, :perishable_token, :string

    User.paper_trail_off!
    User.all.each_with_index do |user, idx|
      user.reset_perishable_token!
      user.reset_single_access_token!
      user.reset_persistence_token!
      user.update_attributes(email: "undefined#{idx}@test.com") unless user.email.present?
    end
    User.paper_trail_on!

    change_column :users, :persistence_token, :string, null: false
    change_column :users, :single_access_token, :string, null: false
    change_column :users, :perishable_token, :string, null: false
    change_column :users, :email, :string, null: false

    add_column :users, :login_count, :integer, null: false, default: 0
    add_column :users, :failed_login_count, :integer, null: false, default: 0
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
  end

  def down
    rename_column :users, :crypted_password, :password_hash
    remove_column :users, :persistence_token
    remove_column :users, :single_access_token
    remove_column :users, :perishable_token
    remove_column :users, :login_count
    remove_column :users, :failed_login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
  end
end
