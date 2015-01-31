class Help::ArticlesController < ApplicationController
  before_action :require_admin, only: [:new, :create, :edit, :update]
  before_action :find_article, only: [:show, :edit, :update]

  def index
    @glossary_type_id = (params[:help].presence || {})[:glossary_type_id]
    @glossary_type_id = @glossary_type_id.present? ? @glossary_type_id : nil

    if current_user.admin?
      @categories = HelpCategory.where(glossary_type_id: @glossary_type_id).list_order.includes([:help_articles])
    else
      @categories = HelpCategory.where(glossary_type_id: @glossary_type_id).published.list_order.includes([:help_articles])
    end
  end

  def new
    @article = HelpArticle.new
  end

  def create
    @article = HelpArticle.new(help_article_params)
    if @article.save
      if params[:do_publish_article].to_s == 'true'
        @article.update_attributes(published_at: Time.zone.now)
        flash_to notice: 'Changes saved! Article published!'
      else
        @article.update_attributes(published_at: nil)
        flash_to notice: 'Changes saved!'
      end
      redirect_to help_article_path(@article)
    else
      flash_to error: @article.errors.full_messages.first
      render action: :new
    end
  end

  def show
    unless current_user.admin?
      if @article.draft?
        flash_to error: 'Sorry, article not found'
        redirect_to help_articles_path
      end
    end
  end

  def edit
  end

  def update
    if @article.update_attributes(help_article_params)
      if params[:do_publish_article].to_s == 'true'
        @article.update_attributes(published_at: Time.zone.now)
        flash_to notice: 'Changes saved! Article published!'
      else
        @article.update_attributes(published_at: nil)
        flash_to notice: 'Changes saved!'
      end
      redirect_to help_article_path(@article)
    else
      flash_to error: @article.errors.full_messages.first
      render action: :edit
    end
  end

  private

  def find_article
    @article = HelpArticle.find(params[:id])
  rescue
    flash_to error: 'Sorry, article not found'
    redirect_to help_articles_path
  end

  def help_article_params
    params.require(:help_article).permit(:help_category_id, :title, :body)
  end
end
