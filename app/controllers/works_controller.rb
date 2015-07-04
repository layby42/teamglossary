class WorksController < ApplicationController
  before_action :find_language
  before_action :find_from_date
  before_action :find_to_date

  def index
    @data = Kaminari.paginate_array(GeneralMenuAction.simple_search(@language, @from_date, @to_date).to_a).page(params[:page])
  end

  def email
    @data = {}
    actions = GeneralMenuAction.simple_search(@language, @from_date, @to_date)
    actions.keys.sort{|x, y| (x.sequence <=> y.sequence) && (x.general_menu_id <=> y.general_menu_id)}.each do |general_menu|
      general_menu_actions = actions[general_menu]
      @data[general_menu.id] ||= {}
      parent = general_menu.general_menu
      if parent && parent.multipart? && (parent.display_name.downcase != general_menu.display_name.downcase)
        @data[general_menu.id][:name] = [parent.display_name, general_menu.display_name].join(': ')
      else
        @data[general_menu.id][:name] = general_menu.display_name
      end
      @data[general_menu.id][:work_done] = general_menu_actions.inject([]) do |result, action|
        name = action.user.try(:name).presence || action.name

        if action.end_date.present?
          person_name = action.task.show_assignee_in_email? ? " by #{name}" : nil
          result << "#{action.task.title_complete.downcase}#{person_name}"
        else
          person_name = action.task.show_assignee_in_email? ? " to #{name}" : nil
          result << "sent for #{action.task.title.downcase}#{person_name}"
        end
        result
      end.reverse.uniq.join(', ')
    end
    UserMailer.work_in_progress_email(current_user, @data, {language: @language, from_date: @from_date, to_date: @to_date}).deliver
    flash_to notice: "Work in progress sent to #{current_user.email}. Please check your mail."
  ensure
    redirect_to action: :index
  end

  private

  def find_language
    if params[:filter].present?
      Setting.update_value!(current_user, :work_language, params[:filter][:language_id])
      @language = Language.active.where(id: params[:filter][:language_id]).first
    else
      language_id = current_user.get_setting_value(:work_language)
      @language = Language.active.where(id: language_id).first if language_id
    end
    @language ||= Language.active.first
  end

  def find_from_date
    if params[:filter].present?
      @from_date = Date.parse(params[:filter][:from_date]) rescue Time.zone.now.beginning_of_week.to_date
      Setting.update_value!(current_user, :work_from_date, @from_date.to_date)
    else
      @from_date = Date.parse(current_user.get_setting_value(:work_from_date)) rescue nil
    end
    @from_date ||= Time.zone.now.beginning_of_week.to_date
  end

  def find_to_date
    if params[:filter].present?
      @to_date = Date.parse(params[:filter][:to_date]) rescue Time.zone.now.end_of_week.to_date
      Setting.update_value!(current_user, :work_to_date, @to_date.to_date)
    else
      @to_date = Date.parse(current_user.get_setting_value(:work_to_date)) rescue nil
    end
    @to_date ||= Time.zone.now.end_of_week.to_date
  end

  def require_xhr
    unless request.xhr?
      redirect_to works_path
    end
  end

  def set_action_title
    @action_title = :work
  end
end
