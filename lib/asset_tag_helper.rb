module ActionView
  module Helpers
    module AssetTagHelper
      
      def javascript_include_tag_with_holly(*sources)
        @holly_logger ||= Holly::Logger.new
        sources = Holly::ScriptFile::Collection.new(*sources).to_a.
            delete_if { |s| @holly_logger.rendered?(s) }
        @holly_logger.log(*sources)
        javascript_include_tag_without_holly(*sources)
      end
      alias_method_chain(:javascript_include_tag, :holly)
      
    end
  end
end
