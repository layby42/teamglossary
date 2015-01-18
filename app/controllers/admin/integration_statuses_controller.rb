class Admin::IntegrationStatusesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :edit, :update, :changes]
  before_action :find_integration_status, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :create, :edit, :update, :changes]

  def index
    @integration_statuses = IntegrationStatus.list_order
  end

  def new
    @integration_status = IntegrationStatus.new()
  end

  def create
    @integration_status = IntegrationStatus.new(integration_status_params)
    if @integration_status.save
      @integration_status.fix_default! if @integration_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @integration_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    old_defaults = IntegrationStatus.default
    if @integration_status.update_attributes(integration_status_params)
      @integration_status.fix_default! if @integration_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @integration_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@integration_status).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_integration_status
    @integration_status = IntegrationStatus.find(params[:id])
  rescue
    flash_to error: 'Sorry, integration status not found'
    redirect_to admin_integration_statuses_path
  end

  def integration_status_params
    params.require(:integration_status).permit(:code, :name, :description, :is_default)
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_integration_statuses_path
    end
  end
end
