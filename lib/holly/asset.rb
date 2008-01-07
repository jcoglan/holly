require 'find'

module Holly
  class Asset
    
    REQUIRE = /^\s*(?:\/\/|\/\*)\s*@require\s+(\S+)/
    LOAD = /^\s*(?:\/\/|\/\*)\s*@load\s+(\S+)/
    
    class << self
      def find_all
        files, dir = [], Holly.public_dir
        Find.find(dir) do |path|
          files << path.gsub(%r{^#{dir}}, "") if path =~ /\.(js|css)$/i
        end
        files.sort.map { |f| self.new(f) }
      end
    end
    
    attr_accessor :source
    
    def initialize(source, context = DEFAULT_TYPE)
      @source = Holly.resolve_source(source, context)
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
    
    def exists?
      !is_local? or File.file?(path)
    end
    
    def read
      @read ||= is_local? ? (exists? ? File.read(path) : "") : ""
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
    
    def expanded
      Collection.new(@source)
    end
    
    def referring_assets
      self.class.find_all.find_all do |asset|
        asset.source != @source and (asset.requires + asset.loads).include?(@source)
      end
    end
    
    def dependant_assets
      self.class.find_all.find_all do |asset|
        asset.source != @source and asset.expanded.sources.include?(@source)
      end
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
