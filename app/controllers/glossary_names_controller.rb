class GlossaryNamesController < LanguagesController
  skip_before_action :require_user, only: [:show]
  before_filter :find_language
  before_filter :find_glossary_name, only: [:show, :edit, :update, :changes, :approve, :reject]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor, only: [:new, :create, :edit, :update, :changes]
  before_filter :require_base_language_manager_or_editor, only: [:approve, :reject]

  def new
    @glossary_name = GlossaryName.new_with_defaults
    @glossary_name.language = @language
  end

  def create
    @glossary_name = GlossaryName.new(glossary_name_params)
    @glossary_name.language_id = @language.id
    if @glossary_name.save
      flash_to notice: 'Changes saved!'
      redirect_to edit_language_glossary_name_path(@language, @glossary_name)
    else
      flash_to error: @glossary_name.errors.full_messages.first
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @glossary_name.update_attributes!(glossary_name_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      flash_to error: @glossary_name.errors.full_messages.first
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_name).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def approve
    @glossary_name.approve!
    flash_to notice: 'Term approved!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_glossary_name_path(@language, @glossary_name)
  end

  def reject
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_name
    @glossary_name = GlossaryName.find(params[:glossary_name_id].presence || params[:id])
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
    language = @glossary_name ? @glossary_name.language : @language
    unless current_user.manager_or_editor?(language.id)
      flash_to error: "Sorry, you must have manager or editor access level to #{language.english_name} glossary"
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

  def require_base_language_manager_or_editor
    unless current_user.manager_or_editor?(base_language.language_id)
      flash_to error: 'Sorry, you must have manager or editor access level to Main glossary'
      redirect_to language_glossary_name_path(@language, @glossary_name)
    end
  end

  def glossary_name_params
    params.require(:glossary_name).permit(
      :term,
      :is_private,
      :integration_status_id,
      :proper_name_type_id,
      :tibetan,
      :sanskrit,
      :explanation,
      :dates
      )
  end

end
