class Admin::ImportsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:general_menu, :hopkins]

  def index
  end

  def general_menu
    raise 'Import file can\'t be blank.' unless params[:file].present?
    ImportGeneralMenuHelper.import!(params[:file])
    flash_to notice: 'General menu imported!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path
  end

  def hopkins
    raise 'Import file can\'t be blank.' unless params[:file_large].present?
    raise 'Import file can\'t be blank.' unless params[:file_small].present?
    ImportHopkinsHelper.import!(params[:file_large], params[:file_small])
    flash_to notice: 'General menu imported!'
  rescue Exception => ex
    p ex.backtrace
    flash_to error: ex.message
  ensure
    redirect_to admin_imports_path
  end
end
