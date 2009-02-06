class CodesController < ApplicationController
  def index
    respond_to do | wants | 
      @codes = codes_for params[:s]
      wants.html { @page_title = "Community-powered gem compatibility for ruby 1.9" }
      wants.json { render :json => @codes }
      wants.xml { render :xml => @codes }
    end
  end
  
  def show
    @code = Code.find_by_slug_name!(params[:slug_name], :include => :comments)
    respond_to do |wants|
      wants.html do
        @page_title = "#{@code.name} gem ruby 1.9 compatibility"
        @comment = Comment.new(:name => cookies[:comment_name], :email => cookies[:comment_email], :url => cookies[:comment_url])
      end
      wants.json { render :json => @code }
      wants.xml { render :xml => @code }
      wants.rss { render :xml => rss_for(@code.comments, :feed_title => "#{@code.name}: ruby 1.9 gem compatibility", :feed_link => code_by_slug_url(@code.slug_name), :feed_description => @code.description_or_summary, :title => :description, :description => :description, :permalink => :permalink, :datetime => :updated_at) }
    end
    
  rescue ActiveRecord::RecordNotFound
    respond_to do |wants|
      wants.html do
        @codes = Code.find_with_ferret(["*", params[:slug_name], "*"].to_s)
        render :action => "no_show", :status => :not_found 
      end
      wants.json { head :status => :not_found }
      wants.xml { head :status => :not_found }
    end
  end
  
private
  def codes_for search_parameter
    if search_parameter.blank?
      @codes = Code.paginate(:per_page => 30, :page => params[:page], :include => [:working_comments, :failure_comments], :order => 'name')
    else
      @codes = Code.find_with_ferret(search_parameter.to_s, { :per_page => 30, :page => params[:page] }, { :include => [:working_comments, :failure_comments], :order => 'name' })
    end
  end
end
