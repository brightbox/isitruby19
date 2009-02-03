module CommentsHelper
  def name_link_for comment
    if comment.url.blank?
      "<span class=\"white\">#{h(comment.name)}</span>"
    else
      "<a href=\"#{h(comment.url)}\" rel=\"nofollow\">#{h(comment.name)}</a>"
    end
  end
end
