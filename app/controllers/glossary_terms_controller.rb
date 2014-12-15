class GlossaryTermsController < LanguagesController
  skip_before_action :require_user, only: [:show]
  before_filter :find_language
  before_filter :find_glossary_term, only: [:show, :edit, :update, :changes, :approve, :reject]

  before_filter :require_xhr, :only => [:edit, :changes]

  before_filter :require_language_manager_or_editor, only: [:new, :create, :edit, :update, :changes]
  before_filter :require_base_language_manager_or_editor, only: [:approve, :reject]

  def new
    @glossary_term = GlossaryTerm.new_with_defaults
    @glossary_term.language = @language
  end

  def create
    @glossary_term = GlossaryTerm.new(glossary_term_params)
    @glossary_term.language_id = @language.id
    if @glossary_term.save
      flash_to notice: 'Changes saved!'
      redirect_to edit_language_glossary_term_path(@language, @glossary_term)
    else
      flash_to error: @glossary_term.errors.full_messages.first
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @glossary_term.update_attributes!(glossary_term_params)
      flash_to notice: 'Changes saved!'
      redirect_to action: :show
    else
      flash_to error: @glossary_term.errors.full_messages.first
      render action: :show
    end
  end

  def changes
    @changes = Change.for_item(@glossary_term).sort {|a, b| b.created_at <=> a.created_at}
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
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_glossary_term
    @glossary_term = GlossaryTerm.find(params[:glossary_term_id].presence || params[:id])
  rescue
    flash_to error: 'Sorry, technical term not found'
    redirect_to root_path
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end

  def require_language_manager_or_editor
    language = @glossary_term ? @glossary_term.language : @language
    unless current_user.manager_or_editor?(language.id)
      flash_to error: "Sorry, you must have manager or editor access level to #{language.english_name} glossary"
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end

  def require_base_language_manager_or_editor
    unless current_user.manager_or_editor?(base_language.language_id)
      flash_to error: 'Sorry, you must have manager or editor access level to Main glossary'
      redirect_to language_glossary_term_path(@language, @glossary_term)
    end
  end

  def glossary_term_params
    params.require(:glossary_term).permit(
      :term,
      :is_private,
      :reference_type_id,
      :general_status_id,
      :integration_status_id,
      :sanskrit_status_id,
      :glossary_term_id,
      :tibetan,
      :alternative_tibetan,
      :sanskrit,
      :alternative_sanskrit,
      :sanscrit_gender,
      :pali,
      :pali_gender,
      :arabic,
      :definition,
      :is_definition_private,
      :additional_explanation
      )
  end
end
