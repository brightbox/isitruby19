class Object # :nodoc:
  def self.path2class(klassname)
    klassname.split('::').inject(Object) { |k,n| k.const_get n }
  end
end
  
class Object
  # return an instance of an Object::Factory
  def self.factory
    @@object_factory ||= Factory.new
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
      @generated_fields = {}
      @confirmed_fields = {}
    end
  
    # Create a new instance of the given class with the given parameters and apply the auto-generated fields, according to the configured rules
    def create_a klass, parameters = {}
      instance = klass.new parameters
      generate_values_for instance, parameters
      generate_confirmations_for instance, parameters
      return instance
    end
    
    # Set up the required auto-generated fields for the given class.  
    #   Object.factory.configure MyClass, :auto_generate => [:field1, :field2], :auto_confirm => [:password]
    # Options are: 
    # * :auto_generate specifies a field name or array of field names that are to have unique string values assigned to them
    # * :auto_confirm specifies a field name or array of field names that are to be set to a unique value; with the same value being assigned to field_name_confirmation
    def when_creating_a klass, options = {}
      need_to_generate_values_for klass, options[:auto_generate] unless options[:auto_generate].nil?
      need_to_confirm_values_for klass, options[:auto_confirm] unless options[:auto_confirm].nil? 
    end

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
    
    private
      
    def symbol_for object
      klass = object.is_a?(Class) ? object : object.class
      return klass.name.to_sym
    end
    
    def need_to_generate_values_for klass, fields
      # we need fields to be Enumerable so put fields into an Array unless it is already Enumerable (and understands the :each message)
      fields = [fields] unless fields.respond_to?(:each)
      @generated_fields[symbol_for(klass)] = fields unless fields.nil?
    end
    
    def need_to_confirm_values_for klass, fields
      fields = [fields] unless fields.respond_to?(:each)
      @confirmed_fields[symbol_for(klass)] = fields
    end
    
    def generate_values_for instance, parameters
      field_names = @generated_fields[symbol_for(instance)]
      return if field_names.nil?
      field_names.each do | field_name |
        value = generator.value_for(instance.class, field_name)
        instance.send("#{field_name.to_s}=".to_sym, value) unless parameters.has_key?(field_name.to_sym)
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
