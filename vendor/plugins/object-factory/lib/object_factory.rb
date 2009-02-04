require 'rubygems'
require 'rujitsu'

class Object
  # return an instance of an Object::Factory
  def self.factory
    THE_OBJECT_FACTORY_INSTANCE
  end
  
  # Factory allows test suites to build new instances of objects, specifying some simple constraints on certain fields
  # If a new instance is created via the factory then that instance can have specialist values automatically applied to given fields, meaning that it should be possible for test cases to build valid objects without having to specify a full valid field-set
  # The factory should not be created directly, but instead accessed through the Object#factory method.  
  # Expected usage: 
  #   Object.factory.configure Person, :auto_generate => [:email, :telephone], :auto_confirm => :password
  #   instance = a Person
  # instance will have a unique value for :email and :telephone and will ensure that :password and :password_confirmation have the same value.  
  class Factory
    attr_accessor :generator
    
    def initialize
      reset
    end

    # Set this factory back to its pristine state, with no objects configured
    def reset
      @confirmed_fields = {}
      @generators = {}
    end
  
    # Create a new instance of the given class with the given parameters and apply the auto-generated fields, according to the configured rules
    def create_a klass, parameters = {}
      instance = klass.new parameters
      
      generate_confirmations_for instance, parameters
      generate_values_for instance, parameters
      
      return instance
    end
    
    # Create a new instance of the given class with the given parameters, auto-generate the field values and then call save!
    def create_and_save_a klass, parameters = {}
      instance = create_a klass, parameters
      raise CannotSaveError, instance.errors.inspect unless instance.save
      return instance
    end
    
    # Set up the required auto-generated fields for the given class.  
    #   Object.factory.when_creating_a MyClass, :auto_generate => [:field1, :field2], :auto_confirm => :password, :generate_email_address => :email_address, :set => { :field3 => 'value3', :field4 => 'value4' }, :generator => { :field5 => lambda {Date.today}, :field6 => lambda {Time.now} }
    # Options are: 
    # * :auto_generate specifies a field name or array of field names that are to have unique string values assigned to them
    # * :auto_confirm specifies a field name or array of field names that are to be set to a unique value; with the same value being assigned to field_name_confirmation
    # * :generate_email_address specifies a field name or array of field names that are set to be randomised email addresses
    # * :set specifies a Hash of field names and fixed values
    # * :generate specifies a Hash of field names and lambdas that are used to generate a dynamic value
    def when_creating_a klass, options = {}
      need_to_generate_values_for klass, options[:auto_generate] unless options[:auto_generate].nil?
      need_to_confirm_values_for klass, options[:auto_confirm] unless options[:auto_confirm].nil? 
      need_to_generate_email_addresses_for klass, options[:generate_email_address] unless options[:generate_email_address].nil?
      need_to_generate_ip_addresses_for klass, options[:generate_ip_address] unless options[:generate_ip_address].nil?
      need_to_set_values_for klass, options[:set] unless options[:set].nil? 
      need_to_set_generators_for klass, options[:generate] unless options[:generate].nil?
    end
    
    alias :when_creating_an :when_creating_a
    alias :create_and_save_an :create_and_save_a

    # An Object::Factory::ValueGenerator that is used to actually build the unique values used to populate the required fields
    def generator
      @generator ||= ValueGenerator.new
    end
    
    # A simple class that generates unique values
    class ValueGenerator
      def initialize
        @counter = 0
      end
      
      def unique_integer
        @counter += 1
      end
      
      def value_for klass, field
        "#{klass.name.to_s}-#{field.to_s}-#{unique_integer}"
      end
    end
    
    #ÊError raised when create_and_save_a cannot save the object
    class CannotSaveError < RuntimeError; end
    
    # print the rules for a given class
    def print_configuration_for klass
      fields_and_generators = @generators[symbol_for(klass)]
      unless fields_and_generators.nil? 
        fields_and_generators.each do | field_name, generator | 
          puts "#{field_name} uses a lambda"
        end
      end
    end
    
    private
      
    def symbol_for object
      klass = object.is_a?(Class) ? object : object.class
      return klass.name.to_sym
    end
    
    def need_to_generate_values_for klass, fields
      fields = [fields] unless fields.respond_to?(:each)
      fields.each do | field | 
        add_generator_for klass, field, lambda { generator.value_for(klass, field) }
      end
    end
    
    def need_to_confirm_values_for klass, fields
      fields = [fields] unless fields.respond_to?(:each)
      @confirmed_fields[symbol_for(klass)] = fields
    end
    
    def need_to_generate_email_addresses_for klass, fields
      fields = [fields] unless fields.respond_to?(:each)
      fields.each do | field |
        add_generator_for klass, field, lambda { 6.random_letters + '@' +  10.random_letters + '.com' }
      end
    end
    
    def need_to_generate_ip_addresses_for klass, fields
      fields = [fields] unless fields.respond_to?(:each)
      fields.each do | field |
        add_generator_for klass, field, lambda {
          octs = []
          4.times { octs << 1.random_numbers(:to => 255) }
          octs.join(".")
        }
      end
    end
    
    def need_to_set_values_for klass, fields_and_values
      fields_and_values.each do | field, value | 
        add_generator_for klass, field, lambda { value }
      end
    end

    def add_generator_for klass, field, generator
      @generators[symbol_for(klass)] ||= {}
      @generators[symbol_for(klass)][field] = generator
    end
    
    def need_to_set_generators_for klass, fields_and_generators
      fields_and_generators.each do | field, generator |
        add_generator_for klass, field, generator
      end
    end
    
    def generate_confirmations_for instance, parameters
      field_names = @confirmed_fields[symbol_for(instance)]
      return if field_names.nil? 
      field_names.each do | field_name |
        confirmation_field_name = "#{field_name}_confirmation"
        value = generator.value_for(instance.class, field_name)
        instance.send("#{field_name.to_s}=".to_sym, value) unless parameters.has_key?(field_name.to_sym)
        instance.send("#{confirmation_field_name.to_s}=".to_sym, value) unless parameters.has_key?(confirmation_field_name.to_sym)
      end
    end
    
    def generate_values_for instance, parameters
      fields_and_generators = @generators[symbol_for(instance)]
      return if fields_and_generators.nil?
      fields_and_generators.each do | field_name, proc | 
        value = proc.call
        instance.send("#{field_name.to_sym}=".to_sym, value) unless parameters.has_key?(field_name.to_sym)
      end
    end
  end
  
end

# Short-cut method for Object::Factory#create_a
# Also aliased as an, for class names that start with a vowel.  
#   instance = a Thingy
#   another_instance = an OtherThingy
def a klass, parameters = {}
  Object.factory.create_a klass, parameters
end

alias an a

# Short-cut method for Object::Factory#create_and_save_a
def a_saved klass, parameters = {}
  Object.factory.create_and_save_a klass, parameters
end

# Short-cut method for Object::Factory#when_creating_a
def when_creating_a klass, options = {}
  Object.factory.when_creating_a klass, options
end

alias when_creating_an when_creating_a

THE_OBJECT_FACTORY_INSTANCE = Object::Factory.new
