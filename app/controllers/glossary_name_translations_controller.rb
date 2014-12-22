class GlossaryNameTranslationsController < GlossaryNamesController
  before_filter :find_language
  before_filter :find_glossary_name
  before_filter :find_glossary_name_translation, only: [:edit, :update, :changes, :destroy]

  before_filter :require_xhr, :only => [:changes]

  before_filter :require_language_manager_or_editor

  def create
    glossary_name_translation = GlossaryNameTranslation.new(glossary_name_translation_params)
    glossary_name_translation.language_id = @language.id
    glossary_name_translation.glossary_name_id = @glossary_name.id
    if glossary_name_translation.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: glossary_name_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_name_path(@language, @glossary_name)
  end

  def edit
  end

  def update
    if @glossary_name_translation.update_attributes!(glossary_name_translation_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @glossary_name_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_glossary_name_path(@language, @glossary_name)
  end

  def changes
    @changes = Change.for_item(@glossary_name_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def destroy
    @glossary_name_translation.destroy
    flash_to notice: 'Translation removed!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_glossary_name_path(@language, @glossary_name)
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_name
    @glossary_name = GlossaryName.find(params[:glossary_name_id])
  rescue
    flash_to error: 'Sorry, proper name not found'
    redirect_to root_path
  end

  def find_glossary_name_translation
    @glossary_name_translation = @language.glossary_name_translations.where(glossary_name_id: @glossary_name.id).find(params[:id])
  rescue
    flash_to error: 'Sorry, proper name translation not found'
    redirect_to language_glossary_name_path(@language, @glossary_name)
  end

  def glossary_name_translation_params
    params.require(:glossary_name_translation).permit(
      :term,
      :alt_term1,
      :alt_term2,
      :alt_term3,
      :notes,
      :integration_status_id
      )
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

  def require_language_manager_or_editor
    unless current_user.manager_or_editor?(@language)
      flash_to error: 'Sorry, you have read-only access to the glossary'
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

end
