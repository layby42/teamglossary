class GlossaryTermsController < LanguagesController
  before_filter :find_language
  before_filter :find_glossary_term, only: [:show, :edit, :update]

  def show
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_term
    @glossary_term = GlossaryTerm.find(params[:id])
  rescue
    flash_to error: 'Sorry, technical term not found'
    redirect_to root_path
  end
end
