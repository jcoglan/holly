module Holly
  class Logger
    
    attr :sources
    
    def initialize
      @sources = []
    end
    
    def log(*sources)
      sources = sources.map { |s| ScriptFile.convert_source(s) }
      @sources = (@sources + sources).uniq
    end
    
    def rendered?(source)
      @sources.include?(ScriptFile.convert_source(source))
    end
    
  end
end
