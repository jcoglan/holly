require File.dirname(__FILE__) + '/../lib/holly'

namespace :holly do
  task :resolve do
    asset = Holly::Asset.new(Holly.resolve_source(ENV["q"], "js"))
    print "\n  Requires:"
    print "\n        (none)" if asset.requires.empty?
    asset.requires.each { |r| print "\n        #{r}" }
    print "\n\n  Loads:"
    print "\n        (none)" if asset.loads.empty?
    asset.loads.each { |l| print "\n        #{l}" }
    print "\n\n  Full stack:"
    Holly::Asset::Collection.new(asset.source).sources.each do |source|
      print "\n    #{source == asset.source ? "->" : "  "}  #{source}"
    end
    print "\n"
  end
end
