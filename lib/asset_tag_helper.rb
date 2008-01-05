module ActionView
  module Helpers
    module AssetTagHelper
      
      def javascript_include_tag_with_holly(*sources)
        @javascript_logger ||= Holly::Logger.new
        sources = sources.map { |s| Holly::ScriptFile.new(path_to_javascript(s)).source }
        @javascript_logger.log(*sources)
        javascript_include_tag_without_holly(*sources)
      end
      alias_method_chain(:javascript_include_tag, :holly)
      
    end
  end
end
