class UpdateGeneralMenuActionsStructure < ActiveRecord::Migration
  def up
    change_column :general_menu_actions, :language_id, :integer, null: false
    change_column :general_menu_actions, :general_menu_id, :integer, null: false
    change_column :general_menu_actions, :start_date, :date, null: false
  end

  def down
  end
end
