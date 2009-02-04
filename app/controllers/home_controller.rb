class HomeController < ApplicationController
  caches_page :show
  
  def show
    @latest_feedback = Comment.latest.all(:limit => 5)
    @popular = Code.popular.all(:limit => 15)
    @unpopular = Code.unpopular.all(:limit => 5)
  end
end
