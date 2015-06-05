class AddTaskDescription < ActiveRecord::Migration
  def change
    add_column :general_menu_actions, :description, :text
  end
end
