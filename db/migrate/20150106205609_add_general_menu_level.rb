class AddGeneralMenuLevel < ActiveRecord::Migration
  def change
    add_column :general_menus, :level, :integer, null: false, default: 0
  end
end
