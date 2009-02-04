dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/../../../lib/spec/rails/extensions/object")

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