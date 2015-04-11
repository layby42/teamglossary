module ApplicationHelper
  def page_title
    title = 'Team Glossary'
    subtitle = controller.class.const_defined?('PAGE_TITLE') ? controller.class.const_get('PAGE_TITLE') : controller_name.humanize.capitalize
    "Team Glossary :: #{subtitle}"
  end

  def link_to_empty(name = nil, html_options = nil, &block)
    link_to(name, 'javascript:void(0);', html_options, &block)
  end

  def active_language_options(selected=nil)
    opts = Language.active.list_order.map{|l| [l.full_name, l.id]}
    options_for_select(opts, selected)
  end

  def glossary_type_except_menu_options(selected=nil)
    opts = GlossaryType.except_menu.list_order.map{|l| [l.name, l.id]}
    options_for_select(opts, selected)
  end

  def glossary_type_options(selected=nil, options={})
    if current_user
      opts = GlossaryType.list_order.map{|l| [l.name, l.id]}
    else
      opts = GlossaryType.except_menu.list_order.map{|l| [l.name, l.id]}
    end
    opts = ([options[:include_blank]] + opts) if options[:include_blank].present?
    options_for_select(opts, selected)
  end

  def poposed_item?(language, item)
    (item.language_id != base_language.id) && !item.is_private
    # language.is_base_language? ? (item.language_id != language.id) : (item.language_id == language.id && !item.is_private)
  end

  def tab_for(tab_name, &block)
    content_tag(:li, :id => "#{tab_name}_tab", :class => (tab_name == @tab ? 'active' : ''), &block)
  end

  def validation_message_for_field(item, field)
    return nil unless item.try(:errors)
    return nil unless item.errors[field]
    item.errors[field].join('; ')
  end

  def time_ago(datetime)
    return '' unless datetime.present?
    "#{time_ago_in_words(datetime)} ago"
  end

  def gender_helper(gender_abbreviation)
    case gender_abbreviation.to_s.upcase
    when 'M'
      content_tag('div', 'masculine', class: 'label label-default')
    when 'F'
      content_tag('div', 'feminine', class: 'label label-default')
    when 'N'
      content_tag('div', 'neutral', class: 'label label-default')
    else
      ''
    end
  end

  def gender_options(selected=nil)
    opts = [['Masculine', 'm'], ['Feminine', 'f'], ['Neutral', 'n']]
    options_for_select(opts, selected)
  end

  def model_to_select(model, selected=nil)
    if model == ProperNameType
      opts = model.all.collect{|m| ["#{m.code} - #{m.name}", m.id, {data: {code: m.code, has_dates: m.has_dates}}]}
    else
      opts = model.all.collect{|m| ["#{m.code} - #{m.name}", m.id, {data: {code: m.code}}]}
    end
    options_for_select(opts, selected)
  end
end
