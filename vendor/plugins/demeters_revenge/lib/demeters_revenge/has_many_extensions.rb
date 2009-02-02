module DemetersRevenge
  module HasManyExtensions
    
    def self.included(base)
      if base.respond_to?(:has_many_without_transmogrifiers)
        raise DemetersRevenge::MultipleTransmogrification
      end
      
      base.instance_eval do
        class << self
          
          def has_many_with_transmogrifiers(name, *args)
            has_many_without_transmogrifiers(name, *args)
            HasManyExtensions.inject_transmogrifiers(self, name)
          end
        
          alias_method_chain(:has_many, :transmogrifiers)
          
        end
      end
    end
    
    def self.inject_transmogrifiers(klass, association_name)
      plural_association_name = association_name.to_s
      singular_association_name = plural_association_name.singularize
      
      klass.instance_eval do 
                
        define_method("build_#{singular_association_name}") do |*args|
          send(plural_association_name).build(*args)
        end
        
        define_method("create_#{singular_association_name}") do |*args|
          send(plural_association_name).create(*args)
        end
        
        define_method("delete_#{singular_association_name}") do |object|
          send(plural_association_name).delete(object)
        end
        
        define_method("clear_#{plural_association_name}") do
          send(plural_association_name).clear
        end
        
        define_method("number_of_#{plural_association_name}") do
          send(plural_association_name).length
        end
        
        define_method("#{singular_association_name}_count") do |*args|
          send(plural_association_name).count(*args)
        end
        
        define_method("has_#{plural_association_name}?") do
          send(plural_association_name).any?
        end
        
        define_method("has_no_#{plural_association_name}?") do
          send(plural_association_name).empty?
        end
        
        define_method("find_#{plural_association_name}") do |*args|
          send(plural_association_name).find(*args)
        end
      end
    end
  end
end