class DeleteFeedTables < ActiveRecord::Migration
  def up
    drop_table :users_feeds
    drop_table :feeds
  end

  def down
    create_table :users_feeds
    create_table :feeds
  end
end
