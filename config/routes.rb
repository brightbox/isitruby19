ActionController::Routing::Routes.draw do |map|

  map.root :controller => "codes", :action => "index"
  map.search "/search/:search", :controller => "codes", :action => "index"
  map.code "/:slug_name", :controller => "codes", :action => "show"
  
  map.resources :code, :shallow => true do |code|
    code.resources :comments
  end
  map.resources :users
  
  map.resources :authors

end
