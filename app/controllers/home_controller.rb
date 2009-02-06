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
    render :xml => rss_for(@comments, :feed_title => 'Ruby 1.9 gem compatibility', :feed_link => root_url, :feed_description => 'Latest comments about gem compatibility for ruby 1.9', :title => :description, :description => :description, :permalink => :permalink, :datetime => :updated_at)
  end
  
end
