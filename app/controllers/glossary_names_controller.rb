class GlossaryNamesController < LanguagesController
  before_filter :find_language
  before_filter :find_glossary_name, only: [:show, :edit, :update, :changes]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor, only: [:new, :create, :edit, :update, :changes]

  def show
  end

  def edit
  end

  def update
    if @glossary_name.update_attributes!(glossary_name_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_name).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_name
    @glossary_name = GlossaryName.find(params[:id])
  rescue
    flash_to error: 'Sorry, proper name not found'
    redirect_to root_path
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

  def require_language_manager_or_editor
    unless current_user.manager_or_editor?(@glossary_name.language_id)
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

  def glossary_name_params
    params.require(:glossary_name).permit(
      :term,
      :is_private,
      :integration_status_id,
      :tibetan,
      :sanskrit,
      :explanation,
      :wade_giles,
      :dates
      )
  end

end
