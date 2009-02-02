module CommentsHelper
  def name_link_for comment
    if comment.url.blank?
      h(comment.name) 
    else
      "<a href=\"#{h(comment.url)}\" rel=\"nofollow\">#{h(comment.name)}</a>"
    end
  end
end
