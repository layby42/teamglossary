class Admin::TasksController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:new, :create, :update, :changes]
  before_action :find_task, only: [:edit, :update, :changes]
  before_filter :require_xhr, :only => [:new, :edit, :changes]

  def index
    @tasks = Task.list_order
  end

  def new
    @task = Task.new()
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @task.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      flash_to notice: 'Changes saved!'
    else
      flash_to error: @task.errors.full_messages.first
    end
    redirect_to action: :index
  end

  def changes
    @changes = Change.for_item(@task).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_task
    @task = Task.find(params[:id])
  rescue
    flash_to error: 'Sorry, task not found'
    redirect_to admin_tasks_path
  end

  def task_params
    params.require(:task).permit(:title, :article, :audio, :video, :title_complete)
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_tasks_path
    end
  end

  def set_action_title
    @action_title = :settings
  end
end
