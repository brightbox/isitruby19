module DemetersRevenge
  module HasAndBelongsToManyExtensions
    
    def self.included(base)
      if base.respond_to?(:has_and_belongs_to_many_without_transmogrifiers)
        raise DemetersRevenge::MultipleTransmogrification
      end
      
      base.instance_eval do
        class << self
          
          def has_and_belongs_to_many_with_transmogrifiers(name, *args)
            has_and_belongs_to_many_without_transmogrifiers(name, *args)
            HasManyExtensions.inject_transmogrifiers(self, name)
          end
        
          alias_method_chain(:has_and_belongs_to_many, :transmogrifiers)
          
        end
      end
    end
    
  end
end