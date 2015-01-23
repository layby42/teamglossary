module WorksHelper
  def work_in_progress_user_name_helper(general_menu_action)
    name = general_menu_action.user.try(:name).presence || general_menu_action.name
    return name unless general_menu_action.user_id.present?
    return name unless current_user && (current_user.admin? || current_user.manager?)
    link_to(name, admin_user_path(general_menu_action.user_id))
  end

  def work_in_progress_short_helper(general_menu_actions)
    general_menu_actions.inject([]) do |result, action|
      result << (action.end_date.present? ? action.task.title_complete.downcase : "sent for #{action.task.title.downcase}")
      result
    end.reverse.join(', ')
  end
end
