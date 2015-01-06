class DropGeneralMenuSiblings < ActiveRecord::Migration
  def up
    drop_table :general_menu_siblings
  end

  def down
    create_table :general_menu_siblings
  end
end
