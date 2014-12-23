class GlossaryTitlesController < LanguagesController
  skip_before_action :require_user, only: [:show]
  before_filter :find_language
  before_filter :find_glossary_title, only: [:show, :edit, :update, :changes, :approve, :reject, :destroy, :propose]

  before_filter :require_xhr, :only => [:changes]

  before_filter :require_language_manager_or_editor, only: [:new, :create, :edit, :update, :changes, :destroy, :propose]
  before_filter :require_base_language_manager_or_editor, only: [:approve, :reject]

  def new
    @glossary_title = GlossaryTitle.new_with_defaults
    @glossary_title.language = @language
  end

  def create
    @glossary_title = GlossaryTitle.new(glossary_title_params)
    @glossary_title.language_id = @language.id
    if @glossary_title.save
      flash_to notice: 'Changes saved!'
      redirect_to edit_language_glossary_title_path(@language, @glossary_title)
    else
      flash_to error: @glossary_title.errors.full_messages.first
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @glossary_title.update_attributes!(glossary_title_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      flash_to error: @glossary_title.errors.full_messages.first
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_title).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def approve
    @glossary_title.approve!
    flash_to notice: 'Term approved!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def reject
    case request.method
    when 'GET'
      unless request.xhr?
        redirect_to language_glossary_title_path(@language, @glossary_title)
      end
    when 'POST'
      @glossary_title.reject!(reject_params[:rejected_because])
      flash_to notice: 'Term rejected!'
      redirect_to language_glossary_title_path(@language, @glossary_title)
    else
      redirect_to language_glossary_title_path(@language, @glossary_title)
    end
    redirect_to language_glossary_title_path(@language, @glossary_title)
  rescue Exception => ex
    flash_to error: ex.message
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def propose
    @glossary_title.update_attributes!(is_private: false)
    if @glossary_title.language.is_base_language?
      flash_to notice: 'Term shared with all language glossaries!'
    else
      flash_to notice: 'Term proposed to the Main glossary!'
    end
    redirect_to language_glossary_title_path(@language, @glossary_title)
  end

  def destroy
    if @glossary_title.glossary_title_translations.count > 0
      raise 'Sorry, you cannot delete text title because it has translations.'
    end
    @glossary_title.destroy
    flash_to notice: 'Text title removed!'
    redirect_to root_path
  rescue Exception => ex
    flash_to error: ex.message
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
    language = @glossary_title ? @glossary_title.language : @language
    unless current_user.manager_or_editor?(language.id)
      flash_to error: "Sorry, you must have manager or editor access level to #{language.english_name} glossary"
      redirect_to language_glossary_title_path(@language, @glossary_title)
    end
  end

  def require_base_language_manager_or_editor
    unless current_user.manager_or_editor?(base_language.id)
      flash_to error: 'Sorry, you must have manager or editor access level to Main glossary'
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
