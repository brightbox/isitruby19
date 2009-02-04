class CodeAndCommentSweeper < ActionController::Caching::Sweeper
  observe :comment, :code
  
  def after_save code_or_comment
    expire code_or_comment
  end
  
  def after_destroy code_or_comment
    expire code_or_comment
  end
  
private
  def expire code_or_comment
    expire_fragment :controller => 'home', :action => 'show'
  end
end