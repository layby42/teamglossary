class AddUpdatedFromCmsDate < ActiveRecord::Migration
  def change
    add_column :general_menus, :updated_from_cms_at, :datetime
    add_column :general_menu_translations, :updated_from_cms_at, :datetime
  end
end
