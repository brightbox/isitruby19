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
    slug = code_or_comment.slug_name
    `rm #{RAILS_ROOT}/public/cache/index.html`
    `rm #{RAILS_ROOT}/public/cache/#{slug}.html`
  end
end