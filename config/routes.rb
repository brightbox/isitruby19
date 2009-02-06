ActionController::Routing::Routes.draw do |map|

  map.root :controller => "home", :action => "show"
  map.rss '/rss', :controller => 'home', :action => 'rss'
  
  map.resources :codes, :shallow => true do |code|
    code.resources :comments
  end
  map.resources :users
  
  map.resources :authors
  
  map.code_by_slug "/:slug_name", :controller => "codes", :action => "show"
  map.code_by_slug_with_format "/:slug_name.:format", :controller => "codes", :action => "show"
  map.comments_by_code_with_format "/:code_id/comments.:format", :controller => "comments", :action => "index"
end
