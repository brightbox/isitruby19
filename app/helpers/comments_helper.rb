module CommentsHelper
  def name_link_for comment
    if comment.url.blank?
      "<span class=\"white\">#{h(comment.name)}</span>"
    else
      "<a href=\"#{h(comment.fixed_url)}\" rel=\"nofollow\">#{h(comment.name)}</a>"
    end
  end
  
  def delete_link_for comment
    return nil if comment.new_record?
    return nil unless my_comments.include?(comment.id)
    link_to "DELETE", comment_path(comment), :method => :delete, :class => 'delete-comment', :confirm => 'Are you sure?'
  end
  
  def opinion_for comment
    if comment.works_for_me?
      "<span class=\"works\">Working</span>"
    else
      "<span class=\"fails\">Failing</span>"
    end
  end

  def format_comment comment
    simple_format(auto_link(h(comment), :link => :urls))
  end
  
end
