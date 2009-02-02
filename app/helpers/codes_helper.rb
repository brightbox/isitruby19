module CodesHelper
  def working_icon_for code
    if code.works? 
      image_tag 'icons/tick.gif', :alt => 'All reports show this gem as working'
    else
      ''
    end
  end
  
  def large_working_icon_for code
    working_icon_for code # TODO: bigger icons
  end
end
