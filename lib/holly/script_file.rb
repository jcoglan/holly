module Holly
  class ScriptFile
    
    class << self
      def convert_source(source)
        source = source.to_s
        source = "/javascripts/#{source}" unless is_remote?(source) or is_absolute?(source)
        source
      end
      
      def is_remote?(source)
        !!(source =~ /^https?:\/\//i)
      end
      
      def is_absolute?(source)
        !!(source =~ /^\//)
      end
    end
    
    attr_accessor :source
    
    def initialize(source)
      @source = self.class.convert_source(source) # will be absolute or remote
      @source.gsub!(/\?.*$/, "") if is_local?
      @source = @source.gsub(/\.js$/i, "") + ".js"
    end
    
    def is_local?
      !self.class.is_remote?(@source)
    end
    
  end
end
