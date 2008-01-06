module ActionView
  module Helpers
    module AssetTagHelper
      
      def javascript_include_tag_with_holly(*sources)
        holly_asset_tags(expand_javascript_sources(sources), "js")
      end
      alias_method_chain(:javascript_include_tag, :holly)
      
      def stylesheet_link_tag_with_holly(*sources)
        holly_asset_tags(expand_stylesheet_sources(sources), "css")
      end
      alias_method_chain(:stylesheet_link_tag, :holly)
      
      def holly_asset_tags(sources, asset_type)
        sources = sources.map { |s| Holly.resolve_source(s.to_s, asset_type) }
        files = Holly::Asset::Collection.new(*sources).files
        files.delete_if { |f| request.holly_logger.rendered?(f.source) }
        request.holly_logger.log(*files.map { |f| f.source})
        files.map { |file|
          __send__("#{file.asset_tag_method}_without_holly", file.source)
        }.join("\n")
      end
      
    end
  end
end
