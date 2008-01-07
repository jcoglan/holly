module Holly
  
  JS_DIR = "javascripts"
  CSS_DIR = "stylesheets"
  DEFAULT_TYPE = "js"
  
  def self.public_dir
    @public_dir || RAILS_ROOT.gsub(/\/$/, "") + "/public"
  end
  
  def self.public_dir=(dir)
    @public_dir = dir
  end
  
  def self.resolve_source(source, context = DEFAULT_TYPE)
    source = source.to_s
    source = source.gsub(/\?.*$/, "") unless is_remote_path?(source)
    extension = determine_extension(source, context)
    source += ".#{extension}" unless source =~ /\.[a-z]+$/i
    unless is_absolute_path?(source) or is_remote_path?(source)
      source = "/#{source =~ /\.css$/i ? CSS_DIR : JS_DIR}/#{source}"
    end
    source
  end
  
  def self.is_absolute_path?(path)
    !!(path =~ /^\//)
  end
  
  def self.is_remote_path?(path)
    !!(path =~ /^https?:\/\//i)
  end
  
  def self.determine_extension(source, context = DEFAULT_TYPE)
    return source.gsub(/^.*?\.([a-z]+)$/i, '\1') if source =~ /\.[a-z]+$/i
    if is_absolute_path?(source)
      return "js" if source =~ %r{^\/#{JS_DIR}\/}
      return "css" if source =~ %r{^\/#{CSS_DIR}\/}
    end
    return context
  end
end

require File.dirname(__FILE__) + '/holly/asset'
require File.dirname(__FILE__) + '/holly/asset/collection'
require File.dirname(__FILE__) + '/holly/logger'
