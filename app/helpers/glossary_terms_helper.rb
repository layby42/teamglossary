module GlossaryTermsHelper
  def glossary_terms_options(language, selected=nil)
    if language.is_base_language?
      conditions = {language_id: language.id, glossary_term_id: nil}
    else
      conditions = {language_id: [language.id, Language.base_language.id], glossary_term_id: nil}
    end

    opts = GlossaryTerm.where(conditions).list_order.pluck(:id, :term).map{|t| [t[1], t[0]]}
    options_for_select(opts, selected)
  end
end
