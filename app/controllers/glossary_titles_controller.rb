class GlossaryTitlesController < LanguagesController
  before_filter :find_language
  before_filter :find_glossary_title, only: [:show, :edit, :update, :changes]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor, only: [:new, :create, :edit, :update, :changes]

  def show
  end

  def edit
  end

  def update
    if @glossary_title.update_attributes!(glossary_title_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_title).sort {|a, b| b.created_at <=> a.created_at}
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
    @glossary_title = GlossaryTitle.find(params[:glossary_title_id].presence || params[:id])
  rescue
    flash_to error: 'Sorry, text title not found'
    redirect_to root_path
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_title_path(@language, @glossary_title)
    end
  end

  def require_language_manager_or_editor
    unless current_user.manager_or_editor?(@glossary_title.language_id)
      redirect_to language_glossary_title_path(@language, @glossary_title)
    end
  end

  def glossary_title_params
    params.require(:glossary_title).permit(
      :term,
      :alt_term1,
      :alt_term2,
      :popular_term,
      :is_private,
      :author,
      :author_translit,
      :tibetan_full,
      :tibetan_short,
      :sanskrit_full,
      :sanskrit_short,
      :sanskrit_full_diacrit,
      :sanskrit_short_diacrit,
      :pali,
      :explanation,
      :integration_status_id
      )
  end

end
