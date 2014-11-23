class Admin::SettingsController < ApplicationController
  before_action :require_admin_or_manager

  def index
  end
end
