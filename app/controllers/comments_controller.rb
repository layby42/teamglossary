class CommentsController < LanguagesController
  before_filter :find_language
  before_filter :find_commentable
  before_filter :find_show_comments, only: [:new, :create]

  before_filter :require_xhr

  def new
    @comment = @commentable.comments.by_language(@language.id).new
  end

  def create
    @comment = @commentable.comments.by_language(@language.id).new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash_to notice: 'Comment added!'
      render action: :create
    else
      flash_to error: @comment.errors.full_messages.first
      render action: :new
    end
  end


  private

  def find_language
    @language = current_user.languages.find(params[:language_id])
  rescue
    flash_to error: 'Sorry, language section not found or you do not have access the language section\'s comments'
    redirect_to root_path
  end

  def find_commentable
    @commentable = nil
    case params[:commentable_type]
    when 'GlossaryTerm'
      @commentable = GlossaryTerm.where(id: params[:commentable_id]).first
    when 'GlossaryName'
      @commentable = GlossaryName.where(id: params[:commentable_id]).first
    when 'GlossaryTitle'
      @commentable = GlossaryTitle.where(id: params[:commentable_id]).first
    end

    unless @commentable.present?
      flash_to error: 'Sorry, term you are looking for not found'
      redirect_to root_path
    end
  end

  def find_show_comments
    @show_comments = (params[:show_comments].presence || true).to_s == 'true'
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
      else
        redirect_to root_path
      end
    end
  end

  def comment_params
    params.require(:comment).permit(
      :text
      )
  end
end
