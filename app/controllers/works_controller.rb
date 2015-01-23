class WorksController < ApplicationController
  before_action :find_language
  before_action :find_from_date
  before_action :find_to_date

  def index
    @data = Kaminari.paginate_array(GeneralMenuAction.simple_search(@language, @from_date, @to_date).to_a).page(params[:page])
    p @data
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
      @from_date = Date.parse(params[:filter][:from_date]) rescue Time.zone.now.beginning_of_week
      Setting.update_value!(current_user, :work_from_date, @from_date.to_date)
    else
      @from_date = Date.parse(current_user.get_setting_value(:work_from_date)) rescue nil
    end
    @from_date ||= Time.zone.now.beginning_of_week
  end

  def find_to_date
    if params[:filter].present?
      @to_date = Date.parse(params[:filter][:to_date]) rescue Time.zone.now.end_of_week
      Setting.update_value!(current_user, :work_to_date, @to_date.to_date)
    else
      @to_date = Date.parse(current_user.get_setting_value(:work_to_date)) rescue nil
    end
    @to_date ||= Time.zone.now.end_of_week
  end
end
