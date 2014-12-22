class GlossaryTitleTranslationsController < GlossaryTitlesController
  before_filter :find_language
  before_filter :find_glossary_title
  before_filter :find_glossary_title_translation, only: [:edit, :update, :changes, :destroy]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor

  def create
    glossary_title_translation = GlossaryTitleTranslation.new(glossary_title_translation_params)
    glossary_title_translation.language_id = @language.id
    glossary_title_translation.glossary_title_id = @glossary_title.id
    if glossary_title_translation.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: glossary_title_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def edit
  end

  def update
    if @glossary_title_translation.update_attributes!(glossary_title_translation_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @glossary_title_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def changes
    @changes = Change.for_item(@glossary_title_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def destroy
    @glossary_title_translation.destroy
    flash_to notice: 'Translation removed!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_title
    @glossary_title = GlossaryTitle.find(params[:glossary_title_id])
  rescue
    flash_to error: 'Sorry, title translation not found'
    redirect_to root_path
  end

  def find_glossary_title_translation
    @glossary_title_translation = @language.glossary_title_translations.where(glossary_title_id: @glossary_title.id).find(params[:id])
  rescue
    flash_to error: 'Sorry, text title translation not found'
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def glossary_title_translation_params
    params.require(:glossary_title_translation).permit(
      :term,
      :alt_term1,
      :alt_term2,
      :alt_term3,
      :author,
      :notes,
      :integration_status_id
      )
  end

end
