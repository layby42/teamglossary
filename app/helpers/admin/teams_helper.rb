module Admin::TeamsHelper
  def language_options(selected=nil)
    opts = Language.list_order.collect{|l| [l.english_name, l.id]}
    options_for_select(opts, selected)
  end

  def user_options(selected=nil)
    opts = User.list_order.collect{|u| [u.name, u.id]}
    options_for_select(opts, selected)
  end

  def role_options(selected=nil)
    opts = LanguageUser::ROLES.collect{|r| [r.to_s.capitalize, r]}
    options_for_select(opts, selected)
  end
end
