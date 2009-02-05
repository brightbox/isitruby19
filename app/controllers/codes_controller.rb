class CodesController < ApplicationController
  def index
    @page_title = "Community-powered gem compatibility for ruby 1.9"
    if params[:s].blank?
      @codes = Code.paginate(:per_page => 30, :page => params[:page], :include => [:working_comments, :failure_comments], :order => 'name')
    else
      @codes = Code.find_with_ferret(["*", params[:s], "*"].to_s, { :per_page => 30, :page => params[:page] }, { :include => [:working_comments, :failure_comments], :order => 'name' })
    end
  end
  
  def show
    @code = Code.find_by_slug_name!(params[:slug_name], :include => :comments)
    respond_to do |wants|
      wants.html {
        @page_title = "#{@code.name} gem ruby 1.9 compatibility"
        @comment = Comment.new
      }
      wants.json { render :json => @code }
      wants.xml { render :xml => @code }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |wants|
      wants.html {
        @codes = Code.find_with_ferret(["*", params[:slug_name], "*"].to_s)
        render :action => "no_show", :status => :not_found 
      }
      wants.json { head :status => :not_found }
      wants.xml { head :status => :not_found }
    end
  end
  
end
