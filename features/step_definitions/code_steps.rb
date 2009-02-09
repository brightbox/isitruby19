Given /^a gem called "(.*)"$/ do | name |
  code = Code.find_by_name name
  code.destroy unless code.nil?  
  code = a_saved Code, :name => name
end

When /^I visit the page for "(.*)"$/ do | name | 
  visit "/#{name}"
end
