class Admin::SanskritStatusesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :edit, :update, :changes]
  before_action :find_sanskrit_status, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :edit, :changes]

  def index
    @sanskrit_statuses = SanskritStatus.list_order
  end

  def new
    @sanskrit_status = SanskritStatus.new()
  end

  def create
    @sanskrit_status = SanskritStatus.new(sanskrit_status_params)
    if @sanskrit_status.save
      @sanskrit_status.fix_default! if @sanskrit_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @sanskrit_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    old_defaults = SanskritStatus.default
    if @sanskrit_status.update_attributes(sanskrit_status_params)
      @sanskrit_status.fix_default! if @sanskrit_status.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @sanskrit_status.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@sanskrit_status).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_sanskrit_status
    @sanskrit_status = SanskritStatus.find(params[:id])
  rescue
    flash_to error: 'Sorry, sanskrit status not found'
    redirect_to admin_sanskrit_statuses_path
  end

  def sanskrit_status_params
    params.require(:sanskrit_status).permit(:code, :name, :description, :is_default)
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_sanskrit_statuses_path
    end
  end
end
