module LanguagesHelper

  def new_glossary_item_url_helper(glossary_type, language)
    case glossary_type.code.upcase
    when 'PPN'
      new_language_glossary_name_path(language)
    when 'THT'
      new_language_glossary_term_path(language)
    when 'TXT'
      new_language_glossary_title_path(language)
    else
      '#'
    end
  end

  def approve_glossary_item_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      approve_language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      approve_language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      approve_language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def reject_glossary_item_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      reject_language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      reject_language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      reject_language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def show_glossary_term_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def base_language_team?
    current_user && current_user.team?(base_language.id)
  end

  def language_team?(language_id)
    current_user && current_user.team?(language_id)
  end

  def can_edit_language_glossary?(language_id)
    current_user && current_user.manager_or_editor?(language_id)
  end

  def bottom_link_style_helper(apply=false)
    apply ? 'position: relative; padding-bottom: 25px;' : ''
  end

  def search_terms_display_options(language, options={})
    opts = {
      language: language,
      language_team: language_team?(language.id),
      can_edit_language_glossary: can_edit_language_glossary?(language.id),
      base_language_team: base_language_team?,
      can_edit_base_language_glossary: can_edit_language_glossary?(base_language.id)
    }
    options.each do |key, value|
      opts[key] = value
    end
    opts
  end

  def add_new_term_translation_language_ids(except_language_ids)
    current_user.write_access_languages.non_base.pluck(:id) - except_language_ids
  end

  def new_translation_language_options(language_ids=[])
    opts = current_user.languages.non_base.where(id: language_ids).collect{|l| [l.english_name, l.id]}
    options_for_select(opts)
  end
end
