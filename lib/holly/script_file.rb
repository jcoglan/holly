module Holly
  class ScriptFile
    
    REQUIRE = /^\s*\/\/\s*@require\s+/
    LOAD = /^\s*\/\/\s*@load\s+/
    
    class << self
      def convert_source(source)
        source = source.to_s
        source = "/javascripts/#{source}" unless is_remote?(source) or is_absolute?(source)
        source.gsub!(/\?.*$/, "") if !is_remote?(source)
        source.gsub(/\.js$/i, "") + ".js"
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
    end
    
    def is_local?
      !self.class.is_remote?(@source)
    end
    
    def path
      is_local? ? "#{PUBLIC_DIR}#{@source}" : @source
    end
    
    def read
      @read ||= is_local? ? File.read(path) : ""
    end
    
    def lines
      @lines ||= read.split(/[\r\n]/).delete_if { |s| s.blank? }
    end
    
    def requires
      @requires ||= lines.
          find_all { |line| line =~ REQUIRE }.
          map { |line| line.strip.gsub(REQUIRE, "") }.
          map { |s| self.class.convert_source(s) }
    end
    
    def loads
      @loads ||= lines.
          find_all { |line| line =~ LOAD }.
          map { |line| line.strip.gsub(LOAD, "") }.
          map { |s| self.class.convert_source(s) }
    end
    
  end
end
