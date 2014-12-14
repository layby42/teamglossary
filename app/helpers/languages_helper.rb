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
    return '#'
    # case glossary_type.code.upcase
    # when 'PPN'
    #   new_language_glossary_name_path(language)
    # when 'THT'
    #   new_language_glossary_term_path(language)
    # when 'TXT'
    #   new_language_glossary_title_path(language)
    # else
    #   '#'
    # end
  end

  def reject_glossary_item_url_helper(language, item)
    '#'
  end


end
