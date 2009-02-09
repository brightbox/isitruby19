require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController do
  describe "creating a comment" do
    it "should create a new comment" do
      @code = mock_model Code, :slug_name => 'thingy'
      @comment = mock_model Comment, :name => 'This', :email => 'That', :url => 'The other'
      
      on_posting_to :create, :code_id => '1', :comment => { :some => :fields } do
        Code.should_receive(:find).with('1').and_return(@code)
        @code.should_receive(:build_comment).with("some" => :fields).and_return(@comment)
        @comment.should_receive(:valid?).and_return(true)
        controller.should_receive(:captcha_is_valid_for).and_return(true)
        @comment.should_receive(:save!).and_return(true)
      end
      
      cookies[:comment_name].should == ['This']
      cookies[:comment_email].should == ['That']
      cookies[:comment_url].should == ['The other']
      session[:my_comments].should == [@comment.id]
      response.should redirect_to(code_by_slug_path('thingy'))
      flash[:notice].should == 'Thanks for your comment'
    end
  end
  
  describe "deleting a comment" do
    it "should allow you to delete if the session marks the comment as one of yours" do
      @comment = mock_model Comment
      session[:my_comments] = [@comment.id]
      
      controller.can_delete(@comment).should be_true
    end

    it "should allow you to delete if the session marks the comment as one of yours" do
      @comment = mock_model Comment
      session[:my_comments] = []
      
      controller.can_delete(@comment).should be_false
    end
  
    it "should not allow you to delete another person's comment" do
      @comment = mock_model Comment, :code_slug_name => 'thingy'

      on_deleting_from :destroy, :id => '1' do
        Comment.should_receive(:find).with('1').and_return(@comment)
        controller.should_receive(:can_delete).with(@comment).and_return(false)  
      end
      
      response.should redirect_to(code_by_slug_path('thingy'))
      flash[:error].should == 'You are not allowed to delete that comment'
    end
    
    it "should allow you to delete your own comments" do
      @comment = mock_model Comment, :code_slug_name => 'thingy'

      on_deleting_from :destroy, :id => '1' do
        Comment.should_receive(:find).with('1').and_return(@comment)
        controller.should_receive(:can_delete).with(@comment).and_return(true)  
        @comment.should_receive(:destroy)
      end
      
      response.should redirect_to(code_by_slug_path('thingy'))
      flash[:notice].should == 'Your comment has been deleted'
    end
  end
end