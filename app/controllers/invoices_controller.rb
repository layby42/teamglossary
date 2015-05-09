class InvoicesController < ApplicationController
  before_action :require_admin_or_manager_or_paid
  before_action :set_filter, only: [:index]
  before_action :find_invoice, only: [:show, :edit, :update, :destroy, :email, :changes]
  before_action :require_owner, only: [:edit, :update, :destroy, :email]
  before_action :require_owner_or_manager, only: [:show]
  before_filter :require_xhr, :only => [:changes]

  def index
    conditions = {year: @year}
    conditions[:month] = @month if @month.present?
    if current_user.admin?
      @invoices = Invoice.where(conditions).list_order.includes([:user]).page(params[:page])
    elsif current_user.manager?
      conditions[:user_id] = current_user.manager_user_ids + [current_user.id]
      @invoices = Invoice.where(conditions).list_order.includes([:user]).page(params[:page])
    else
      @invoices = current_user.invoices.where(conditions).list_order.includes([:user]).page(params[:page])
    end
  end

  def new
    @invoice = current_user.invoices.new(status: :draft, year: Time.zone.now.year, month: Time.zone.now.month)
  end

  def create
    @invoice = current_user.invoices.new(params_invoice)
    @invoice.status = :draft.to_s
    if @invoice.save
      flash_to notice: 'Invoice saved!'
      redirect_to invoice_path(@invoice)
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @invoice.update_attributes(params_invoice)
      flash_to notice: 'Invoice saved!'
      redirect_to action: :show
    else
      render action: :edit
    end
  end

  def destroy

  end

  def email
    Invoice.transaction do
      UserMailer.invoice_email(current_user, @invoice, {invoice_url: invoice_url(@invoice)}).deliver
      @invoice.sent!
    end
    flash_to notice: "Invoice sent."
  rescue Exception => ex
    flash_to error: ex.message
  ensure
    redirect_to action: :show
  end

  def changes
    @changes = Change.for_item(@invoice).sort {|a, b| b.created_at <=> a.created_at}
    render template: 'admin/changes/changes'
  end

  private

  def find_invoice
    @invoice = Invoice.find(params[:id])
  end

  def require_owner
    unless @invoice.owned_by?(current_user)
      flash_to error: 'Sorry, you must be the invoice owner to proceed'
      redirect_to invoice_path(@invoice)
    end
  end

  def require_owner_or_manager
    unless current_user.admin? || current_user.manager_user_ids.include?(@invoice.user_id) || @invoice.owned_by?(currnet_user)
      flash_to error: 'Sorry, you cannot manage requested invoice'
      redirect_to admin_invoices_path
    end
  end

  def params_invoice
    params.require(:invoice).permit(:month, :year, :hours, :amount, :description)
  end

  def set_filter
    if params[:filter].present?
      @month = params[:filter][:month].to_i if (1..12).include?(params[:filter][:month].to_i)
      @year = params[:filter][:year].to_i if (2000..Time.zone.now.year).include?(params[:filter][:year].to_i)
    else
      @month = Time.zone.now.month
    end
    @year ||= Time.zone.now.year
  end

  def require_xhr
    unless request.xhr?
      redirect_to admin_invoices_path
    end
  end

  def set_action_title
    @action_title = 'Invoices'
  end
end
