class GlossaryTermTranslationsController < GlossaryTermsController
  before_filter :find_glossary_term_translation, only: [:show, :edit, :update, :changes]

  before_filter :require_xhr, :only => [:edit, :changes]

  def edit
  end

  def update
    if @glossary_term_translation.update_attributes!(glossary_term_translation_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_term_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
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

  def glossary_term_translation_params
    params.require(:glossary_term_translation).permit(
      :term,
      :alt_term1,
      :alt_term2,
      :alt_term3,
      :notes,
      :term_gender,
      :definition,
      :integration_status_id
      )
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end
end
