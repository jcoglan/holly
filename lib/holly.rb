module Holly
  
  PUBLIC_DIR = $holly_test_path || RAILS_ROOT.gsub(/\/$/, "") + "/public"
  JS_DIR = "javascripts"
  CSS_DIR = "stylesheets"
  
  def self.resolve_source(source, extension = nil)
    source = source.to_s
    source.gsub!(/\?.*$/, "") unless is_remote_path?(source)
    extension = determine_extension(source, extension)
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
  
  def self.determine_extension(source, extension = nil)
    if is_absolute_path?(source)
      extension ||= "js" if source =~ %r{\/#{JS_DIR}\/}
      extension ||= "css" if source =~ %r{\/#{CSS_DIR}\/}
    end
    extension || "js"
  end
end
