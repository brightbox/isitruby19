class CommentsController < ApplicationController
  cache_sweeper :code_and_comment_sweeper
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
