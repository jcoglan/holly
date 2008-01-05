module Holly
  class Logger
    
    attr :sources
    
    def initialize
      @sources = []
    end
    
    def log(*sources)
      sources = sources.map { |s| Asset.convert_source(s) }
      @sources = (@sources + sources).uniq
    end
    
    def rendered?(source)
      @sources.include?(Asset.convert_source(source))
    end
    
  end
end
