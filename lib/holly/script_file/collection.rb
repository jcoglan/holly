module Holly
  class ScriptFile
    class Collection
      
      def initialize(*sources)
        @sources = sources.uniq
        @files = @sources.map { |s| ScriptFile.new(s) }
        expand!
      end
      
      def expand!
        n = @files.size
        while true
          @sources = @files.map { |f| f.requires + [f.source] + f.loads }.flatten.uniq
          @files = @sources.map { |s| ScriptFile.new(s) }
          return if n == @files.size
          n = @files.size
        end
      end
      
      def to_a
        @files.map { |f| f.source }
      end
      
    end
  end
end
