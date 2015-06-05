class GeneralMenusController < LanguagesController
  before_filter :find_language
  before_action :require_admin, only: [:destroy]
  before_filter :find_general_menu, only: [:show, :edit, :update, :changes, :open, :destroy]

  before_filter :require_xhr, :only => [:changes]

  def open
    flash[:notice] = nil
    unless request.xhr?
      redirect_to root_path
      return
    end

    @data = @general_menu.children(@language)
  end

  def edit
  end

  def update
    if @general_menu.update_attributes!(general_menu_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @general_menu.errors.full_messages.first
    end
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def changes
    @changes = Change.for_item(@general_menu).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  def destroy
    if @general_menu.general_menus.count > 0
      raise 'Sorry, you cannot delete general menu item because it has nested general menu items.'
    end

    if @general_menu.general_menu_actions.count > 0
      raise 'Sorry, you cannot delete general menu item because it has tasks.'
    end

    @general_menu.destroy
    flash_to notice: 'General menu removed!'
    redirect_to admin_diagnostics_path
  rescue Exception => ex
    flash_to error: ex.message
    redirect_to admin_diagnostics_path
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

  def general_menu_params
    params.require(:general_menu).permit(
      :new_name
      )
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_general_menu_path(@language, @general_menu)
    end
  end
end
