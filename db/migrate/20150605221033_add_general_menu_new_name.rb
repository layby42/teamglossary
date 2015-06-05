class AddGeneralMenuNewName < ActiveRecord::Migration
  def change
    add_column :general_menus, :new_name, :string, limit: 1000
    add_column :general_menu_translations, :new_name, :string, limit: 1000
  end
end
