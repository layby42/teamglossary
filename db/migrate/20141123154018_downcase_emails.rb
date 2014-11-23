class DowncaseEmails < ActiveRecord::Migration
  def up
    execute('UPDATE users SET email = lower(email);')
  end

  def down
  end
end
