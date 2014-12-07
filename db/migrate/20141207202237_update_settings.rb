class UpdateSettings < ActiveRecord::Migration
  def up
    execute('DELETE FROM settings;')
    remove_column :settings, :value_type
    change_column :settings, :value, :text
    change_column :settings, :configurable_id, :integer, null: false
    change_column :settings, :configurable_type, :string, null: false
    change_column :settings, :name, :string, limit: 250, null: false
  end

  def down
    add_column :settings, :value_type, :string
  end
end
