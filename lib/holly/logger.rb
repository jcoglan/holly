module Holly
  class Logger
    
    attr :sources
    
    def initialize
      @sources = []
    end
    
    def log(*sources)
      sources = sources.map { |s| Holly.resolve_source(s) }
      @sources = (@sources + sources).uniq
    end
    
    def rendered?(source)
      @sources.include?(Holly.resolve_source(source))
    end
    
  end
end
