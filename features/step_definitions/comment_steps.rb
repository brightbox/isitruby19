Then /^I see the comment form$/ do
  response.should have_tag('div#new-comment-form')
end

When /^I add a comment$/ do
  fill_in "Name", :with => 'Henry the Tester'
  fill_in "Email", :with => 'henry@testing.com'
  choose :comment_works_for_me_true
  fill_in "Version", :with => '1.0'
  fill_in "Platform", :with => 'Mac OSX'
  fill_in :comment_body, :with => 'Here is my test comment' # have to request via ID rather than label because of the span around the optional, making it hard to find
end

Then /^I see my comment on the page$/ do
  response.should include_text('Here is my test comment')
end


