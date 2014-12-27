class GeneralMenusController < LanguagesController
  before_filter :find_language
  before_filter :find_general_menu, only: [:show, :edit, :update, :changes, :open, :destroy]

  before_filter :require_xhr, :only => [:changes]

  def open
    unless request.xhr?
      redirect_to root_path
      return
    end

    @data = @general_menu.children(@language)
  end

  def edit
  end

  def changes
    @changes = Change.for_item(@general_menu).sort {|a, b| b.created_at <=> a.created_at}
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
    @general_menu = GeneralMenu.find(params[:general_menu_id].presence || params[:id])
  rescue
    flash_to error: 'Sorry, general menu item not found'
    redirect_to root_path
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_general_menu_path(@language, @general_menu)
    end
  end
end
