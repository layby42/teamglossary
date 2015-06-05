class GeneralMenuTranslationsController < GeneralMenusController
  before_filter :find_language
  before_filter :find_general_menu
  before_filter :find_general_menu_translation, only: [:edit, :update, :changes, :destroy]

  before_filter :require_xhr, :only => [:changes]

  def create
    general_menu_translation = GeneralMenuTranslation.new(general_menu_translation_params)
    general_menu_translation.language_id = @language.id
    general_menu_translation.general_menu_id = @general_menu.id
    if general_menu_translation.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: general_menu_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def edit
  end

  def update
    update_attributes = if @general_menu_translation.synchronized?
      {notes: general_menu_translation_params[:notes], new_name: general_menu_translation_params[:new_name]}
    else
      nil
    end

    if @general_menu_translation.update_attributes!(update_attributes || general_menu_translation_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @general_menu_translation.errors.full_messages.first
    end
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def changes
    @changes = Change.for_item(@general_menu_translation).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_language
    @language = Language.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found'
    redirect_to root_path
  end

  def find_general_menu
    @general_menu = GeneralMenu.find(params[:general_menu_id].presence)
  rescue
    flash_to error: 'Sorry, general menu item not found'
    redirect_to root_path
  end


  def find_general_menu_translation
    @general_menu_translation = @language.general_menu_translations.where(general_menu_id: @general_menu.id).find(params[:id])
  rescue
    flash_to error: 'Sorry, general menu translation not found'
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def general_menu_translation_params
    params.require(:general_menu_translation).permit(
      :name,
      :new_name,
      :additional_text,
      :online,
      :notes
      )
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_general_menu_path(@language, @general_menu)
    end
  end
end
