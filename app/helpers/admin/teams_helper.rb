module Admin::TeamsHelper
  def language_options(selected=nil)
    if current_user.admin?
      opts = Language.list_order.collect{|l| [l.english_name, l.id]}
    elsif current_user.manager?
      language_ids = current_user.language_users.where(role: :manager).pluck(:language_id)
      opts = Language.where(id: language_ids).list_order.collect{|l| [l.english_name, l.id]}
    else
      opts = []
    end
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
