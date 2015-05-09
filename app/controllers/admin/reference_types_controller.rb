class Admin::ReferenceTypesController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :edit, :update, :changes]
  before_action :find_reference_type, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :edit, :changes]

  def index
    @reference_types = ReferenceType.list_order
  end

  def new
    @reference_type = ReferenceType.new()
  end

  def create
    @reference_type = ReferenceType.new(reference_type_params)
    if @reference_type.save
      @reference_type.fix_default! if @reference_type.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @reference_type.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    old_defaults = ReferenceType.default
    if @reference_type.update_attributes(reference_type_params)
      @reference_type.fix_default! if @reference_type.is_default?
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @reference_type.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@reference_type).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_reference_type
    @reference_type = ReferenceType.find(params[:id])
  rescue
    flash_to error: 'Sorry, reference type not found'
    redirect_to admin_reference_types_path
  end

  def reference_type_params
    params.require(:reference_type).permit(:code, :name, :description, :is_default)
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_reference_types_path
    end
  end

  def set_action_title
    @action_title = 'Reference Types'
  end
end
