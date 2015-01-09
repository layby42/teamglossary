class Admin::DiagnosticsController < ApplicationController
  before_action :require_admin

  def index
    if GeneralMenu.where('general_menus.general_menu_id IS NOT NULL AND general_menus.level = 0').count > 0
      GeneralMenu.fix_level!
    end
    @general_menus = GeneralMenu.broken.order('general_menus.full_cms_path').includes([:language, :general_menu_actions])
  end

end
