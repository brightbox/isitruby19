class CommentsController < ApplicationController
  cache_sweeper :code_and_comment_sweeper
  skip_before_filter :verify_authenticity_token 
  
  # index expects to be called in the context of a Code
  # so a code_id is passed in
  def index
    @code = Code.find_by_slug_name! params[:code_id]
    respond_to do |wants|
      wants.json { render :json => @code.comments }
      wants.xml { render :xml => @code.comments }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |wants|
      wants.json { head :status => :not_found }
      wants.xml { head :status => :not_found }
    end
  end
  
  # create expects to be called in the context of a Code
  # so a code_id is passed in
  def create
    @code = Code.find params[:code_id]
    @comment = @code.build_comment params[:comment]

    # validate the comment, then test the captcha to ensure all errors are shown on the form    
    @comment.valid?
    raise ActiveRecord::RecordInvalid.new(@comment) unless captcha_is_valid_for @comment, :with => params
    @comment.save!    
    
    cookies[:comment_name] = @comment.name
    cookies[:comment_email] = @comment.email
    cookies[:comment_url] = @comment.url
    my_comments << @comment.id
    flash[:notice] = 'Thanks for your comment'
    redirect_to code_by_slug_path(@code.slug_name)
    
  rescue ActiveRecord::RecordInvalid
    render :template => 'codes/show'
    flash[:error] = 'Sorry, unable to save your comment'
  end
  
  # destroy expects to be called with just an id, no code_id necessary
  def destroy
    @comment = Comment.find params[:id]
    if can_delete @comment
      @comment.destroy
      flash[:notice] = 'Your comment has been deleted'
    else
      flash[:error] = 'You are not allowed to delete that comment'
    end
    redirect_to code_by_slug_path(@comment.code_slug_name)
  end

  def can_delete comment
    my_comments.include? comment.id
  end

private
  def my_comments
    session[:my_comments] ||= []
  end

  def captcha_is_valid_for comment, options 
    return true if ENV['RAILS_ENV'] == 'test' # captcha is always valid in test mode
    return validate_recap(options[:with], comment.errors, :rcc_pub => RECAPTCHA_PUBLIC_KEY, :rcc_priv => RECAPTCHA_PRIVATE_KEY)  
  end

end
