class Admin::SettingsController < ApplicationController
  before_action :require_admin_or_manager

  def index
  end

  def set_action_title
    @action_title = :settings
  end
end
