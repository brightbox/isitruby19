=begin rdoc
Module with a set of matchers for examining ActionController::Response objects
=end
module ResponseMatchers
  # test for a 201 response
  def be_successfully_created 
    ResponseStatusMatcher.new "201 Created"
  end
  
  # test for a 422 response
  def be_unprocessable
    ResponseStatusMatcher.new "422 Unprocessable Entity"
  end 
  
  # test for a 404 response
  def be_not_found
    ResponseStatusMatcher.new "404 Not Found"
  end
  
  # test for a 401 response
  def be_unauthorised
    ResponseStatusMatcher.new "401 Unauthorized"
  end
  alias :be_unauthorized :be_unauthorised
  
  # test for a 500 internal server error 
  def be_an_error
    ResponseStatusMatcher.new "500 Internal Error"
  end
  
  # test that the location points to a given URI
  def point_to url
    ResponseLocationMatcher.new url
  end
  
  # Response matcher that examines ActionController::Response headers for the required status code
  class ResponseStatusMatcher
    # Set up this matcher as required
    def initialize status_code
      @status_code = status_code
    end

    # Does the given target object match the required status code?
    def matches? target
      target.headers['Status'] == @status_code
    end
    
    # What do we tell the user when it fails?
    def failure_message
      "expected the response to be #{@status_code}"
    end
    
    # What do we tell the user when it shouldn't fail but does
    def negative_failure_message
      "expected the response to be different to #{@status_code}"
    end
  end
  
  # Response matcher that examines ActionController::Response headers for the given location code
  class ResponseLocationMatcher
    def initialize url
      @url = url
    end
    
    # Does the given target object match the required location?
    def matches? target
      target.headers['Location'] == @url
    end
    
    # What do we tell the user when it fails?
    def failure_message
      "expected the location header to be #{@url}"
    end
    
    # What do we tell the user when it shouldn't fail but does
    def negative_failure_message
      "expected the location header to be different to #{@url}"
    end
  end

end