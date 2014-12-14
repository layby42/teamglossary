module Admin::ChangesHelper

  def formatted_change_user(change)
    user = change.user
    if user
      link_to user.name, admin_user_path(user)
    elsif change.whodunnit.present?
      "Unknown or deleted user (#{change.whodunnit})"
    else
      'No user'
    end
  end

  def formatted_change_title(change)
    event = (change.event + 'd').capitalize
    object = change.item_type.capitalize
    "#{event} #{object}"
  end

  def formatted_change_description(change)
    return '' if change.event == 'create'
    p change
    change_description = (change.changeset || {})
    content_tag(:ul) do
      change_description.map do |key, value|
        content_tag(:li) do
          content_tag(:strong, "#{key.capitalize}:") +
          content_tag(:p, content_tag(:strong, 'NEW: ') + "#{formatted_change_value(value[1])}") +
          content_tag(:p, content_tag(:strong, 'OLD: ') + "#{formatted_change_value(value[0])}")
        end
      end.join.html_safe
    end
  end

  def formatted_change_value(value)
    case value.class.to_s
    when 'Time'
      as_datetime(value)
    when 'Date'
      as_date(value)
    else
      value
    end
  end

end
