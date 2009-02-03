class CodesController < ApplicationController

  def index
    if params[:s].blank?
      @codes = Code.paginate(:per_page => 30, :page => params[:page], :include => [:working_comments, :failure_comments], :order => 'name')
    else
      @codes = Code.find_with_ferret(["*", params[:s], "*"].to_s, { :per_page => 30, :page => params[:page] }, { :include => [:working_comments, :failure_comments], :order => 'name' })
    end
  end
  
  def show
    @code = Code.find_by_slug_name!(params[:slug_name])
    @comment = Comment.new

  rescue ActiveRecord::RecordNotFound
    @codes = Code.find_with_ferret(["*", params[:slug_name], "*"].to_s)
    render :action => "no_show", :status => :not_found 
  end
  
end
