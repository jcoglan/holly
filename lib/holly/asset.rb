module Holly
  class Asset
    
    REQUIRE = /^\s*(?:\/\/|\/\*)\s*@require\s+(\S+)/
    LOAD = /^\s*(?:\/\/|\/\*)\s*@load\s+(\S+)/
    
    attr_accessor :source
    
    def initialize(source)
      @source = Holly.resolve_source(source)
    end
    
    def is_local?
      !Holly.is_remote_path?(@source)
    end
    
    def path
      is_local? ? "#{Holly.public_dir}#{@source}" : @source
    end
    
    def asset_type
      @source.match(/\.([a-z]+)$/i).to_a[1]
    end
    
    def asset_tag_method
      asset_type == "css" ? :stylesheet_link_tag : :javascript_include_tag
    end
    
    def read
      @read ||= is_local? ? (File.file?(path) ? File.read(path) : "") : ""
    end
    
    def lines
      @lines ||= read.split(/[\r\n]/).delete_if { |s| s.empty? }
    end
    
    def requires
      @requires ||= parse(REQUIRE)
      @requires.dup
    end
    
    def loads
      @loads ||= parse(LOAD)
      @loads.dup
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
