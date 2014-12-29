module Admin::UsersHelper

  def user_options_helper(language, selected=nil)
    opts = (language.users + User.where(id: selected)).uniq.collect{|u| [u.name, u.id]}.sort{|x, y| x[0] <=> y[0]}
    options_for_select(opts, selected)
  end

end
