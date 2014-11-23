class RemoveFaIcon < ActiveRecord::Migration
  def up
    remove_column :proper_name_types, :fa_icon
  end

  def down
    add_column :proper_name_types, :fa_icon, :string
  end
end
