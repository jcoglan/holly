module Holly
  class Asset
    class Collection
      
      attr_accessor :sources
      
      def initialize(*sources)
        @sources = sources.map { |s| Holly.resolve_source(s) }.uniq
        expand!
      end
      
      def expand!
        n = @sources.size
        while true
          # Expand files in reverse order. @load-ed files are not reloaded if tmp
          # already contains them, so files are loaded as late as possible.
          # @require-d files are bumped as early in the list as they are needed.
          @sources = files.reverse.inject([]) do |tmp, file|
            (file.requires + [file.source] +
                file.loads.delete_if { |f| tmp.include?(f) } + tmp).flatten.uniq
          end
          return if n == @sources.size
          n = @sources.size
        end
      end
      
      def files
        @sources.map { |s| Asset.new(s) }
      end
      
    end
  end
end
