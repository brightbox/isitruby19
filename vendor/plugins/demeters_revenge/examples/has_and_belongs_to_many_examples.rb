require File.join(File.dirname(__FILE__), *%w[example_spec_helper])

describe "Person that has_and_belongs_to_many Widgets" do
  
  before(:all) do
    ExampleSpecHelper.create_example_database do
      create_table :people, :force => true do |t|
        t.string :name
      end
    
      create_table :widgets, :force => true do |t|
        t.string  :name
      end
      
      create_table :people_widgets, :force => true do |t|
        t.integer :person_id
        t.integer :widget_id
      end
    end
    
    Person = Class.new(ActiveRecord::Base)
    Widget = Class.new(ActiveRecord::Base)
    
    Person.send(:include, DemetersRevenge::HasAndBelongsToManyExtensions)
  end
  
  after(:all) do
    ExampleSpecHelper.destroy_example_database
    Object.send(:remove_const, :Person)
    Object.send(:remove_const, :Widget)
  end
  
  before(:each) do
    Person.send(:has_and_belongs_to_many, :widgets)
    @person = Person.create
  end
  
  after(:each) do
    Person.delete_all
    Widget.delete_all
  end
  
  it "should be able to build widgets and report how many widgets it has" do
    @person.build_widget(:name => 'Widget One')
    @person.build_widget(:name => 'Widget Two')
    @person.number_of_widgets.should == 2
  end
  
  it "should be able to create widgets in the database and return a count" do
    @person.create_widget(:name => 'Widget One')
    @person.create_widget(:name => 'Widget Two')
    @person.widget_count.should == 2
  end
  
  it "should clear all widgets from the collection" do
    @person.build_widget(:name => 'Widget One')
    @person.clear_widgets
    @person.number_of_widgets.should == 0
  end
  
  it "should have no widgets by default" do
    @person.should have_no_widgets
  end
  
  it "should have widgets once at least on has been added" do
    @person.create_widget(:name => 'Widget One')
    @person.should have_widgets
  end
  
  it "should be able to delete created widgets" do
    widget = @person.create_widget
    @person.delete_widget(widget)
    @person.widget_count.should == 0
  end
  
  it "should be able to find an existing widget" do
    widget = @person.create_widget
    @person.find_widgets(:first).should == widget
  end
  
end