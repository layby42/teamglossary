class Admin::HelpCategoriesController < ApplicationController
  before_action :require_admin
  before_action :find_help_category, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :edit, :changes]

  def index
    @help_categories = HelpCategory.list_order
  end

  def new
    @help_category = HelpCategory.new()
  end

  def create
    @help_category = HelpCategory.new(help_category_params)
    if @help_category.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @help_category.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    if @help_category.update_attributes(help_category_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @help_category.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@help_category).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_help_category
    @help_category = HelpCategory.find(params[:id])
  rescue
    flash_to error: 'Sorry, help category not found'
    redirect_to admin_help_categories_path
  end

  def help_category_params
    params.require(:help_category).permit(:title, :glossary_type_id)
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_help_categories_path
    end
  end

  def set_action_title
    @action_title = 'Help Categories'
  end
end
