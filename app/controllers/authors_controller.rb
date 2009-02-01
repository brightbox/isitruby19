class AuthorsController < ApplicationController
  
  def index
    
  end
  
  def show
    @author = Author.find_by_name(params[:id].gsub(/\-/, " "))
    raise ActiveRecord::RecordNotFound unless @author
  end
  
end
