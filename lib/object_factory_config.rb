def prepare_object_factory
  when_creating_a Code, :auto_generate => :name
  
  when_creating_a Comment, 
    :auto_generate => :name, 
    :generate_email_address => :email, 
    :generate => { 
      :code => lambda { a_saved Code }, 
      :platform => lambda { Platform.first }
    }
end