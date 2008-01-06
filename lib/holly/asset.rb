module Holly
  class Asset
    
    REQUIRE = /^\s*(?:\/\/|\/\*)\s*@require\s+(\S+)/
    LOAD = /^\s*(?:\/\/|\/\*)\s*@load\s+(\S+)/
    
    attr :source
    
    def initialize(source)
      @source = Holly.resolve_source(source)
    end
    
    def is_local?
      !Holly.is_remote_path?(@source)
    end
    
    def path
      is_local? ? "#{PUBLIC_DIR}#{@source}" : @source
    end
    
    def asset_type
      @source.match(/\.([a-z]+)$/i).to_a[1]
    end
    
    def read
      @read ||= is_local? ? File.read(path) : ""
    end
    
    def lines
      @lines ||= read.split(/[\r\n]/).delete_if { |s| s.blank? }
    end
    
    def requires
      @requires ||= parse(REQUIRE)
    end
    
    def loads
      @loads ||= parse(LOAD)
    end
    
  private
    
    def parse(pattern)
      lines.
          map { |l| l.match(pattern).to_a[1] }.
          delete_if { |s| s.to_s == "" }.
          map { |s| Holly.resolve_source(s, asset_type) }
    end
    
  end
end
