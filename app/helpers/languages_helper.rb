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

  def propose_glossary_item_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      propose_language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      propose_language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      propose_language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def show_glossary_term_url_helper(language, item, full=false)
    case item.class.to_s
    when 'GlossaryName'
      full ? language_glossary_name_url(language, item) : language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      full ? language_glossary_term_url(language, item) : language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      full ? language_glossary_title_url(language, item) : language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def edit_glossary_term_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      edit_language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      edit_language_glossary_term_path(language, item)
    when 'GlossaryTitle'
      edit_language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def changes_glossary_term_url_helper(language, item)
    case item.class.to_s
    when 'GlossaryName'
      changes_language_glossary_name_path(language, item)
    when 'GlossaryTerm'
      changes_language_glossary_term_path(language, item)
    when 'GlossaryTitle'
     changes_language_glossary_title_path(language, item)
    else
      '#'
    end
  end

  def edit_glossary_term_translation_url_helper(language, item, translation)
    case item.class.to_s
    when 'GlossaryName'
      edit_language_glossary_name_glossary_name_translation_path(language, item, translation)
    when 'GlossaryTerm'
      edit_language_glossary_term_glossary_term_translation_path(language, item, translation)
    when 'GlossaryTitle'
      edit_language_glossary_title_glossary_title_translation_path(language, item, translation)
    else
      '#'
    end
  end

  def changes_glossary_term_translation_url_helper(language, item, translation)
    case item.class.to_s
    when 'GlossaryName'
      changes_language_glossary_name_glossary_name_translation_path(language, item, translation)
    when 'GlossaryTerm'
      changes_language_glossary_term_glossary_term_translation_path(language, item, translation)
    when 'GlossaryTitle'
     changes_language_glossary_title_glossary_title_translation_path(language, item, translation)
    else
      '#'
    end
  end

  def title_helper(item)
    case item.class.to_s
    when 'GlossaryName'
      'PROPER NAME'
    when 'GlossaryTerm'
      'TECHNICAL TERM'
    when 'GlossaryTitle'
      'TEXT TITLE'
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
