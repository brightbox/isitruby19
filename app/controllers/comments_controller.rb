class CommentsController < ApplicationController
  cache_sweeper :code_and_comment_sweeper
  skip_before_filter :verify_authenticity_token 
  
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
  
  def create
    @code = Code.find params[:code_id]
    @comment = @code.build_comment params[:comment]
    @comment.valid?
    raise ActiveRecord::RecordInvalid.new(@comment) unless validate_recap(params, @comment.errors, :rcc_pub => RECAPTCHA_PUBLIC_KEY, :rcc_priv => RECAPTCHA_PRIVATE_KEY)
    @comment.save!    
    flash[:notice] = 'Thanks for your comment'
    redirect_to code_by_slug_path(@code.slug_name)
    
  rescue ActiveRecord::RecordInvalid
    render :template => 'codes/show'
    flash[:error] = 'Sorry, unable to save your comment'
  end
end
