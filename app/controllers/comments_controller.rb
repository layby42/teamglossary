class CommentsController < LanguagesController
  before_filter :find_language, except: [:index]
  before_filter :find_commentable, only: [:new, :create]
  before_filter :find_show_comments, only: [:new, :create, :edit, :update]
  before_filter :find_comment, only: [:edit, :update, :destroy]

  before_filter :find_list_language, only: [:index]
  before_filter :find_list_from_date, only: [:index]
  before_filter :find_list_to_date, only: [:index]

  before_filter :require_xhr, except: [:index]
  before_action :require_admin, only: [:edit, :update]

  def index
    @data = Kaminari.paginate_array(Comment.simple_search(@language, @from_date, @to_date)).page(params[:page])
  end

  def new
    @comment = @commentable.comments.by_language(@language.id).new
  end

  def create
    @comment = @commentable.comments.by_language(@language.id).new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash_to notice: 'Comment added!'
      render action: :refresh
    else
      flash_to error: @comment.errors.full_messages.first
      render action: :new
    end
  end

  def update
    if params[:new_language_id].to_i != @comment.language_id
      new_language = Language.where(id: params[:new_language_id]).first
      @comment.language_id = new_language.id
      if @comment.save
        flash_to notice: "Comment moved to #{new_language.english_name} team!"
        render action: :refresh
      else
        flash_to error: @comment.errors.full_messages.first
        render action: :edit
      end
    else
      render action: :refresh
    end
  end

  def destroy
    unless current_user.manager_or_editor?(@language.id)
      unless @comment.user_id == current_user.id
        raise 'Sorry, you can delete only own comments.'
      end

      last_comment = @comment.commentable.last_comment(@language.id)
      unless last_comment && last_comment.id == @comment.id
        raise 'Sorry, you can delete only last own comment.'
      end
    end

    @comment.destroy
    flash_to notice: 'Comment removed!'
    render action: :refresh

  rescue Exception => ex
    flash_to error: ex.message
    render action: :refresh
  end


  private

  def find_language
    @language = current_user.languages.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found or you do not have access to the language section\'s comments'
    render action: :refresh
    return
  end

  def find_commentable
    @commentable = nil
    if params[:commentable_type].present?
      @commentable = Object.const_get(params[:commentable_type]).where(id: params[:commentable_id]).first
    end

    unless @commentable.present?
      flash_to error: 'Sorry, term you are looking for not found'
      render action: :refresh
      return
    end
  end

  def find_show_comments
    @show_comments = (params[:show_comments].presence || true).to_s == 'true'
  end

  def find_comment
    @comment = @language.comments.find(params[:id])
    @commentable = @comment.commentable
  rescue
    flash_to error: 'Sorry, comment not found'
    render action: :refresh
    return
  end

  def find_list_language
    if params[:filter].present?
      Setting.update_value!(current_user, :discussion_language, params[:filter][:language_id])
      @language = Language.active.where(id: params[:filter][:language_id]).first
    else
      language_id = current_user.get_setting_value(:discussion_language)
      @language = Language.active.where(id: language_id).first if language_id
    end
    @language ||= Language.active.first
  end

  def find_list_from_date
    if params[:filter].present?
      @from_date = Date.parse(params[:filter][:from_date]) rescue Time.zone.now.beginning_of_week.to_date
      Setting.update_value!(current_user, :discussion_from_date, @from_date.to_date)
    else
      @from_date = Date.parse(current_user.get_setting_value(:discussion_from_date)) rescue nil
    end
    @from_date ||= Time.zone.now.beginning_of_week.to_date
  end

  def find_list_to_date
    if params[:filter].present?
      @to_date = Date.parse(params[:filter][:to_date]) rescue Time.zone.now.end_of_week.to_date
      Setting.update_value!(current_user, :discussion_to_date, @to_date.to_date)
    else
      @to_date = Date.parse(current_user.get_setting_value(:discussion_to_date)) rescue nil
    end
    @to_date ||= Time.zone.now.end_of_week.to_date
  end

  def require_xhr
    unless request.xhr?
      case @commentable.class.to_s
      when 'GlossaryTerm'
        redirect_to language_glossary_term_path(@language, @commentable)
      when 'GlossaryName'
        redirect_to language_glossary_name_path(@language, @commentable)
      when 'GlossaryTitle'
        redirect_to language_glossary_title_path(@language, @commentable)
      when 'GeneralMenu'
        redirect_to language_general_menu_path(@language, @commentable)
      else
        redirect_to root_path
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
