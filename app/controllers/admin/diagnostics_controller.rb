class Admin::DiagnosticsController < ApplicationController
  before_action :require_admin

  def index
    updated_from_cms_at = GeneralMenu.pluck(:updated_from_cms_at).uniq.compact.max
    @general_menus = (
      GeneralMenu.broken.includes([:language, :general_menu_actions]) +
      GeneralMenu.where('general_menus.updated_from_cms_at < ?', updated_from_cms_at).includes([:language, :general_menu_actions])
    ).sort{|x, y| x.full_cms_path <=> y.full_cms_path}

  end

end
