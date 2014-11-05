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

  def glossary_type_options(selected=nil)
    opts = GlossaryType.list_order.map{|l| [l.name, l.id]}
    options_for_select(opts, selected)
  end

  def poposed_item?(language, item)
    language.is_base_language? ? (item.language_id != language.id) : (item.language_id == language.id && !item.is_private)
  end
end
