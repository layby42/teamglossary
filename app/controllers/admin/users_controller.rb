class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :find_user, only: [:show, :edit, :update]
  before_action :find_tab, only: [:new, :create, :edit, :update]

  def index
    @users = User.list_order.includes([:languages])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
