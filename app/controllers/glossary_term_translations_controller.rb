class GlossaryTermTranslationsController < GlossaryTermsController
  before_filter :find_language
  before_filter :find_glossary_term
  before_filter :find_glossary_term_translation, only: [:edit, :update, :changes, :destroy]

  before_filter :require_xhr, :only => [:changes]

  before_filter :require_language_manager_or_editor

  def create
    glossary_term_translation = GlossaryTermTranslation.new(glossary_term_translation_params)
    glossary_term_translation.language_id = @language.id
    glossary_term_translation.glossary_term_id = @glossary_term.id
    if glossary_term_translation.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: glossary_term_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_term_path(@language, @glossary_term)
  end

  def edit
  end

  def update
    if @glossary_term_translation.update_attributes!(glossary_term_translation_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @glossary_term_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_term_path(@language, @glossary_term)
  end

  def changes
    @changes = Change.for_item(@glossary_term_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def destroy
    @glossary_term_translation.destroy
    flash_to notice: 'Translation removed!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_glossary_term_path(@language, @glossary_term)
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
    @glossary_term_translation = @language.glossary_term_translations.where(glossary_term_id: @glossary_term.id).find(params[:id])
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

  def require_language_manager_or_editor
    unless current_user.manager_or_editor?(@language)
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end
end
