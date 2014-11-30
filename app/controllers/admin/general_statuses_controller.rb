class Admin::GeneralStatusesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :edit, :update, :changes]
  before_action :find_general_status, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :create, :edit, :update, :changes]

  def index
    @general_statuses = GeneralStatus.list_order
  end

  def new
    @general_status = GeneralStatus.new()
  end

  def create
    @general_status = GeneralStatus.new(general_status_params)
    if @general_status.save
      @general_status.fix_default! if @general_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @general_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    old_defaults = GeneralStatus.default
    if @general_status.update_attributes(general_status_params)
      @general_status.fix_default! if @general_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @general_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@general_status).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_general_status
    @general_status = GeneralStatus.find(params[:id])
  rescue
    flash_to error: 'Sorry, general status not found'
    redirect_to admin_general_statuses_path
  end

  def general_status_params
    params.require(:general_status).permit(:code, :name, :description, :is_default, :is_private)
  end

  def require_xhr
    unless request.xhr?
      admin_general_statuses_path
    end
  end
end
