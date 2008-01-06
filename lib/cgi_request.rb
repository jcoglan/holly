module ActionController
  class CgiRequest
    
    attr_accessor :holly_logger
    
    def initialize_with_holly(*args)
      @holly_logger = Holly::Logger.new
      initialize_without_holly(*args)
    end
    alias_method_chain(:initialize, :holly)
    
  end
end
