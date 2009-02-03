class HomeController < ApplicationController
  def show
    @latest_feedback = Comment.latest.all(:limit => 5)
    @popular = Code.popular.all(:limit => 10)
    @unpopular = Code.unpopular.all(:limit => 5)
    @compatibility = Code.compatibility
  end
end
