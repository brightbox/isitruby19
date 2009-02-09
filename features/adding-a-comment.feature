Feature: adding a comment

  As a Ruby developer
  I would like to comment on a gem
  So that I can help the community track which gems work with Ruby 1.9
  
  Scenario: adding a comment

    Given an initialised database  
    And a gem called "rubynuts"
    
    When I visit the page for "rubynuts"
    Then I see the comment form
    
    When I add a comment
    And I press "submit comment"
    Then I see my comment on the page
    
  Scenario: adding a comment and then deleting it
  
    GivenScenario: adding a comment
    
    When I visit the page for "rubynuts"
    Then I see the delete comment link
    
    When I click the delete comment link
    Then I do not see my comment on the page
  
  Scenario: viewing someone else's comment 
    
    Given an initialised database
    And a gem called "rubynuts"
    And a comment against "rubynuts"
    
    When I visit the page for "rubynuts"
    Then I do not see the delete comment link