class CommentsController < ApplicationController
  def create
    @code = Code.find params[:code_id]
    @comment = @code.build_comment params[:comment]
    @comment.save!
    flash[:notice] = 'Thanks for your comment'
    redirect_to code_by_slug_path(@code.slug_name)
    
  rescue ActiveRecord::RecordInvalid
    render :template => 'codes/show'
    flash[:error] = 'Sorry, unable to save your comment'
  end
end
