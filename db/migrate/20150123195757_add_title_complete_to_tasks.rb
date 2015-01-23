class AddTitleCompleteToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :title_complete, :string
    execute('UPDATE tasks SET title_complete = title;')
    change_column :tasks, :title_complete, :string, null: false
  end

  def down
    remove_column :tasks, :title_complete
  end
end
