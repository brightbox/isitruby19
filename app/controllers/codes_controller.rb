class CodesController < ApplicationController
  
  def index
    unless params[:search]
      @codes = Code.last_thirty_active.all
    else
      @codes = Code.find_with_ferret(["*", params[:search], "*"].to_s)
    end
  end
  
  def show
    @code = Code.find_by_slug_name(params[:slug_name])
    unless @code
      @codes = Code.find_with_ferret(["*", params[:search], "*"].to_s)
      render :action => "no_show", :status => :not_found 
    end
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
end
