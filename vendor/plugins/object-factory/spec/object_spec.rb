require File.expand_path(File.dirname(__FILE__) + '/../lib/object_factory.rb')

class TestClass
  attr_accessor :field, :another_field, :password, :password_confirmation, :other, :other_confirmation
  def initialize parameters = nil
    self.field = parameters[:field]
    self.another_field = parameters[:another_field]
    self.password = parameters[:password]
    self.password_confirmation = parameters[:password_confirmation]
  end
end

class AnotherTestClass

end

describe Object, "with RSpec/Rails extensions" do
  describe "accessing the factory" do
    it "should return an object factory" do
      Object.factory.class.should == Object::Factory
    end
    
    it "should use a single instance" do
      @first_factory = Object.factory
      @second_factory = Object.factory
      
      @first_factory.should == @second_factory
    end
  end
end

describe Object::Factory::ValueGenerator do
  it "should generate a unique string value for a given class and field" do
    @generator = Object::Factory::ValueGenerator.new

    @value = @generator.value_for TestClass, :field
    @value.should match(/TestClass\-field\-(\d+)/)
  end
  
  it "should generate a unique integer value" do
    @generator = Object::Factory::ValueGenerator.new
  
    @first_value = @generator.unique_integer
    @second_value = @generator.unique_integer
    
    @first_value.should_not == @second_value
  end
  
end

describe Object::Factory, "creating simple instances" do

  before :each do 
    Object.factory.reset 
  end

  it "should create an instance of the given class with no provided parameters" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({}).and_return(@test_instance)
    
    @created_instance = Object.factory.create_a(TestClass)
    @created_instance.should == @test_instance
  end
  
  it "should create an instance of the given class with the given parameters" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({:some => :values}).and_return(@test_instance)
    
    @created_instance = Object.factory.create_a(TestClass, :some => :values)
    @created_instance.should == @test_instance
  end
  
  it "should allow 'a' as a short-cut to creating objects" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({}).and_return(@test_instance)

    @created_instance = a TestClass
    @created_instance.should == @test_instance
  end
  
  it "should allow 'an' as a short-cut to creating objects" do
    @test_instance = mock('Test Instance')
    AnotherTestClass.should_receive(:new).with({}).and_return(@test_instance)

    @created_instance = an AnotherTestClass
    @created_instance.should == @test_instance
  end
  
  it "should auto-save the created object" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({:some => :values}).and_return(@test_instance)
    @test_instance.should_receive(:save).and_return(true)
    
    @created_instance = Object.factory.create_and_save_a(TestClass, :some => :values)
  end
  
  it "should raise an exception if the auto-saved object cannot be saved" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({:some => :values}).and_return(@test_instance)
    @test_instance.should_receive(:save).and_return(false)
    
    lambda { 
      Object.factory.create_and_save_a(TestClass, :some => :values)
    }.should raise_error(Object::Factory::CannotSaveError)
  end
  
  it "should allow 'a_saved' as a short-cut to creating and saving an object" do
    @test_instance = mock('Test Instance')
    TestClass.should_receive(:new).with({:some => :values}).and_return(@test_instance)
    @test_instance.should_receive(:save).and_return(true)
    
    @created_instance = a_saved(TestClass, :some => :values)
  end
end
  
describe Object::Factory, "configuring a class" do
  it "should allow 'when_creating_a' as a short-cut to configuring a class" do
    Object.factory.should_receive(:when_creating_a)
    
    when_creating_a TestClass, :auto_generate => :employee_code
  end


end
  
describe Object::Factory, "creating instances with generated values" do
  
  before :each do 
    Object.factory.reset 
  end

  it "should auto-generate a unique value for a configured field" do
    Object.factory.generator.should_receive(:value_for).with(TestClass, :field).and_return("TestClass-field-1")

    Object.factory.when_creating_a TestClass, :auto_generate => :field
    @instance = Object.factory.create_a TestClass
    @instance.field.should == 'TestClass-field-1'
  end
  
  it "should auto-generate unique values for multiple configured fields" do
    Object.factory.generator.should_receive(:value_for).with(TestClass, :field).and_return("TestClass-field-1")
    Object.factory.generator.should_receive(:value_for).with(TestClass, :another_field).and_return("TestClass-another_field-1")

    Object.factory.when_creating_a TestClass, :auto_generate => [:field, :another_field]

    @instance = Object.factory.create_a TestClass
    @instance.field.should match(/TestClass-field-(\d+)/)
    @instance.another_field.should match(/TestClass-another_field-(\d+)/)
  end
  
  it "should allow you to override generated values" do
    Object.factory.when_creating_a TestClass, :auto_generate => :field

    @instance = Object.factory.create_a TestClass, :field => 'My Override Value'
    @instance.field.should == 'My Override Value'
  end

  it "should allow you to override generated values with nils" do
    Object.factory.when_creating_a TestClass, :auto_generate => :field

    @instance = Object.factory.create_a TestClass, :field => nil
    @instance.field.should be_nil
  end
end

describe Object::Factory, "creating instances with confirmed values" do

  before :each do 
    Object.factory.reset 
  end

  it "should auto-generate a unique value for a configured field and its confirmation field" do
    Object.factory.generator.should_receive(:value_for).with(TestClass, :password).and_return("TestClass-password-1")

    Object.factory.when_creating_a TestClass, :auto_confirm => :password

    @instance = Object.factory.create_a TestClass
    @instance.password.should == 'TestClass-password-1'
    @instance.password_confirmation.should == @instance.password
  end

  it "should auto-generate unique values for multiple configured fields and confirmation fields" do
    Object.factory.generator.should_receive(:value_for).with(TestClass, :password).and_return("TestClass-password-1")
    Object.factory.generator.should_receive(:value_for).with(TestClass, :other).and_return("TestClass-other-1")

    Object.factory.when_creating_a TestClass, :auto_confirm => [:password, :other]

    @instance = Object.factory.create_a TestClass
    @instance.password.should match(/TestClass-password-(\d+)/)
    @instance.password_confirmation.should == @instance.password
    @instance.other.should match(/TestClass-other-(\d+)/)
    @instance.other_confirmation.should == @instance.other
  end
  
  it "should allow you to override confirmed original values" do
    Object.factory.when_creating_a TestClass, :auto_confirm => :password

    @instance = Object.factory.create_a TestClass, :password => 'My Override Value'
    @instance.password.should == 'My Override Value'
    @instance.password_confirmation.should_not == @instance.password
  end

  it "should allow you to override confirmed confirmation fields" do
    Object.factory.when_creating_a TestClass, :auto_confirm => :password

    @instance = Object.factory.create_a TestClass, :password_confirmation => 'My Override Value'
    @instance.password_confirmation.should == 'My Override Value'
    @instance.password_confirmation.should_not == @instance.password
  end

  it "should allow you to override confirmed values with nils" do
    Object.factory.when_creating_a TestClass, :auto_confirm => :password

    @instance = Object.factory.create_a TestClass, :password => nil
    @instance.password.should be_nil
    @instance.password_confirmation.should_not == @instance.password
  end

  it "should allow you to override confirmed confirmation fields with nils" do
    Object.factory.when_creating_a TestClass, :auto_confirm => :password

    @instance = Object.factory.create_a TestClass, :password_confirmation => nil
    @instance.password_confirmation.should be_nil
    @instance.password_confirmation.should_not == @instance.password
  end
end

describe Object::Factory, "setting static values" do
  before :each do 
    Object.factory.reset 
  end

  it "should set a static value for a configured field" do
    Object.factory.when_creating_a TestClass, :set => { :field => 'hello' }
    @instance = Object.factory.create_a TestClass
    @instance.field.should == 'hello'
  end
  
  it "should set static values for multiple configured fields" do
    Object.factory.when_creating_a TestClass, :set => { :field => 'hello', :another_field => 'world' }

    @instance = Object.factory.create_a TestClass
    @instance.field.should == 'hello'
    @instance.another_field.should == 'world'
  end
end

describe Object::Factory, "generating email addresses" do
  before :each do
    Object.factory.reset
  end
  
  it "should generate a random email address for a configured field" do
    Object.factory.when_creating_a TestClass, :generate_email_address => :field
    
    @instance = Object.factory.create_a TestClass
    @instance.field.should match(/(.*)@(.*)\.com/)
  end

  it "should generate random email addresses for multiple configured fields" do
    Object.factory.when_creating_a TestClass, :generate_email_address => [:field, :another_field]
    
    @instance = Object.factory.create_a TestClass
    @instance.field.should match(/(.*)@(.*)\.com/)
    @instance.another_field.should match(/(.*)@(.*)\.com/)
  end
end

describe Object::Factory, "generating ip addresses" do
  before :each do
    Object.factory.reset
  end
  
  it "should generate a random ip address for a configured field" do
    Object.factory.when_creating_a TestClass, :generate_ip_address => :field
    
    @instance = Object.factory.create_a TestClass
    @instance.field.should match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
  end
  
  it "should generate a random ip address for multiple configured fields" do
    Object.factory.when_creating_a TestClass, :generate_ip_address => [:field, :another_field]
    
    @instance = Object.factory.create_a TestClass
    @instance.field.should match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
    @instance.another_field.should match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
  end
end

describe Object::Factory, "using lambdas to generate values" do
  before :each do
    Object.factory.reset
  end
  
  it "should set a lambda-generator for configured fields" do
    Object.factory.when_creating_a TestClass, :generate => { :field => lambda { "poop" }, :another_field => lambda { Date.today.to_s } }
    
    @instance = Object.factory.create_a TestClass
    @instance.field.should == 'poop'
    @instance.another_field.should == Date.today.to_s
  end
end