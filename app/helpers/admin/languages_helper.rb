module Admin::LanguagesHelper

  def language_users_sorted(language, role=nil)
    conditions = {}
    conditions[:role] = role if role.present?
    language.language_users.where(conditions).includes([:user]).sort do |x, y|
      x.user.name <=> y.user.name
    end
  end

  def roles_options_helper(selected=nil)
    opts = LanguageUser::ROLES.collect{|r| [r.to_s.capitalize, r.to_s]}
    opts += ['Delete from Team', nil]
    options_for_select(opts, selected)
  end

end
