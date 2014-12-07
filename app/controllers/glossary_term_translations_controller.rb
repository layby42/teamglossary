class GlossaryTermTranslationsController < GlossaryTermsController
  before_filter :find_glossary_term_translation, only: [:show, :edit, :update]

  before_filter :require_xhr, :only => [:edit]

  def edit
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_term
    @glossary_term = GlossaryTerm.find(params[:glossary_term_id])
  rescue
    flash_to error: 'Sorry, technical term not found'
    redirect_to root_path
  end

  def find_glossary_term_translation
    @glossary_term_translation = GlossaryTermTranslation.find(params[:id])
  rescue
    flash_to error: 'Sorry, technical term translation not found'
    redirect_to language_glossary_term_path(@language, @glossary_term)
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end
end
