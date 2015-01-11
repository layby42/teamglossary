class Admin::ProperNameTypesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :edit, :update, :changes]
  before_action :find_proper_name_type, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :create, :edit, :update, :changes]

  def index
    @proper_name_types = ProperNameType.list_order
  end

  def new
    @proper_name_type = ProperNameType.new()
  end

  def create
    @proper_name_type = ProperNameType.new(proper_name_type_params)
    if @proper_name_type.save
      @proper_name_type.fix_default! if @proper_name_type.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @proper_name_type.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    old_defaults = ProperNameType.default
    if @proper_name_type.update_attributes(proper_name_type_params)
      @proper_name_type.fix_default! if @proper_name_type.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @proper_name_type.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@proper_name_type).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_proper_name_type
    @proper_name_type = ProperNameType.find(params[:id])
  rescue
    flash_to error: 'Sorry, proper name type not found'
    redirect_to admin_proper_name_types_path
  end

  def proper_name_type_params
    params.require(:proper_name_type).permit(
      :code,
      :name,
      :description,
      :is_default,
      :has_dates)
  end

  def require_xhr
    unless request.xhr?
      admin_proper_name_types_path
    end
  end
end
