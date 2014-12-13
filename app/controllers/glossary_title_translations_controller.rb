class GlossaryTitleTranslationsController < GlossaryTitlesController
  before_filter :find_glossary_title_translation, only: [:show, :edit, :update, :changes]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor, only: [:create, :edit, :update, :changes]

  def create
    glossary_title_translation = GlossaryTitleTranslation.new(glossary_title_translation_params)
    glossary_title_translation.language = @language
    glossary_title_translation.glossary_term = @glossary_title
    if glossary_title_translation.save
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :show
    end
  end

  def edit
  end

  def update
    if @glossary_title_translation.update_attributes!(glossary_title_translation_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_title_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
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
