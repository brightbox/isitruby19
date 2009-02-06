class HomeController < ApplicationController
  def show
    @page_title = 'Community-powered gem compatibility for ruby 1.9'
    unless read_fragment :controller => 'home', :action => 'show'
      @latest_feedback = Comment.latest.all(:limit => 5)
      @popular = Code.popular.all(:limit => 15)
      @unpopular = Code.unpopular.all(:limit => 5)
    end
  end
  
  def rss
    @comments = Comment.latest.all(:limit => 20, :include => [:code, :platform])
    render :xml => rss_for(@comments, :title => :code_name, :description => :description, :permalink => :permalink, :datetime => :updated_at)
  end
  
private
end
