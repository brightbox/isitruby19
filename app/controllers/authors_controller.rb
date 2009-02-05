class AuthorsController < ApplicationController
    
  def show
    @author = Author.find_by_slug_name!(params[:id])
    respond_to do |wants|
      wants.html    
      wants.json { render :json => @author }
      wants.xml { render :xml => @author }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |wants|
      wants.json { head :status => :not_found }
      wants.xml { head :status => :not_found }
    end
  end
  
end
