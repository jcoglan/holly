module Holly
  class Asset
    
    REQUIRE = /^\s*\/\/\s*@require\s+/
    LOAD = /^\s*\/\/\s*@load\s+/
    
    attr :source
    
    def initialize(source)
      @source = Holly.resolve_source(source) # will be absolute or remote
    end
    
    def is_local?
      !Holly.is_remote_path?(@source)
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
          map { |s| Holly.resolve_source(s) }
    end
    
    def loads
      @loads ||= lines.
          find_all { |line| line =~ LOAD }.
          map { |line| line.strip.gsub(LOAD, "") }.
          map { |s| Holly.resolve_source(s) }
    end
    
  end
end
