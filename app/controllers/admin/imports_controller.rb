class Admin::ImportsController < ApplicationController
  before_action :require_admin_or_manager
  before_action :require_admin, only: [:general_menu]

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
end
