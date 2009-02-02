class CodesController < ApplicationController
  
  def index
    unless params[:search]
      @codes = Code.paginate(:per_page => 30, :page => params[:page])
    else
      @codes = Code.find_with_ferret(["*", params[:search], "*"].to_s)
    end
  end
  
  def show
    @code = Code.find_by_slug_name!(params[:slug_name])

  rescue ActiveRecord::RecordNotFound
    @codes = Code.find_with_ferret(["*", params[:slug_name], "*"].to_s)
    render :action => "no_show", :status => :not_found 
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
