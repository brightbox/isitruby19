Given /^a comment against "(.*)"$/ do | name | 
  code = Code.find_by_name! name
  comment = a_saved Comment, :code => code
end


Then /^I see the comment form$/ do
  response.should have_tag('div#new-comment-form')
end

When /^I add a comment$/ do
  fill_in "Name", :with => 'Henry the Tester'
  fill_in "Email", :with => 'henry@testing.com'
  choose :comment_works_for_me_true
  fill_in "Version", :with => '1.0'
  select 'Mac OSX', :from => 'Platform'
  fill_in :comment_body, :with => 'Here is my test comment' # have to request via ID rather than label because of the span around the optional, making it hard to find
end

When /^I click the delete comment link$/ do
  click_link 'DELETE'
end


Then /^I see my comment on the page$/ do
  response.should include_text('Here is my test comment')
end

Then /^I see the delete comment link$/ do
  response.should have_tag('a.delete-comment')
end

Then /^I do not see the delete comment link$/ do
  response.should_not have_tag('a.delete-comment')
end


Then /^I do not see my comment on the page$/ do
  response.should_not include_text('Here is my test comment')
end
