class GlossaryTitlesController < LanguagesController
  before_filter :find_language
  before_filter :find_glossary_title, only: [:show, :edit, :update]

  def show
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_title
    @glossary_title = GlossaryTitle.find(params[:id])
  rescue
    flash_to error: 'Sorry, text title not found'
    redirect_to root_path
  end
end
