class GeneralMenuActionsController < GeneralMenusController
  before_filter :find_language
  before_filter :find_general_menu
  before_filter :require_language_manager
  before_filter :find_general_menu_action, only: [:edit, :update, :changes, :destroy]
  before_filter :find_show_tasks, only: [:new, :create, :edit, :update]

  before_filter :require_xhr, :only => [:new, :edit, :changes]

  def new
    @general_menu_action = @general_menu.general_menu_actions.by_language(@language.id).new(start_date: Time.zone.now.to_date)
  end

  def create
    general_menu_action = GeneralMenuAction.new(general_menu_action_params)
    general_menu_action.language_id = @language.id
    general_menu_action.general_menu_id = @general_menu.id
    if general_menu_action.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: general_menu_action.errors.full_messages.first
    end
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def update
    if @general_menu_action.update_attributes!(general_menu_action_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @general_menu_action.errors.full_messages.first
    end
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def destroy
    @general_menu_action.destroy
    flash_to notice: 'Task removed!'
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def changes
    @changes = Change.for_item(@general_menu_action).sort {|a, b| b.created_at <=> a.created_at}
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

  def find_general_menu_action
    @general_menu_action = @general_menu.general_menu_actions.by_language(@language.id).find(params[:id])
  rescue
    flash_to error: 'Sorry, general menu task not found'
    redirect_to language_general_menu_path(@language, @general_menu)
  end

  def find_show_tasks
    @show_tasks = (params[:show_tasks].presence || true).to_s == 'true'
  end

  def require_xhr
    unless request.xhr?
      redirect_to language_general_menu_path(@language, @general_menu)
    end
  end

  def general_menu_action_params
    params.require(:general_menu_action).permit(
      :task_id,
      :start_date,
      :end_date,
      :user_id,
      :name
      )
  end

  def require_language_manager
    unless current_user.manager?(@language.id)
      redirect_to language_general_menu_path(@language, @general_menu)
    end
  end
end
