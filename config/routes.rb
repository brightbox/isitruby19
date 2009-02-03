ActionController::Routing::Routes.draw do |map|

  map.root :controller => "home", :action => "show"
  
  map.resources :codes, :shallow => true do |code|
    code.resources :comments
  end
  map.resources :users
  
  map.resources :authors
  map.code_by_slug "/:slug_name", :controller => "codes", :action => "show"

end
