require File.dirname(__FILE__) + '/../lib/holly'

namespace :holly do
  task :resolve do
    asset = Holly::Asset.new(ENV["q"])
    
    print "\n  Requires:"
    print "\n        (none)" if asset.requires.empty?
    asset.requires.each { |r| print "\n    #{Holly.get_symbol(r)}  #{r}" }
    
    print "\n\n  Loads:"
    print "\n        (none)" if asset.loads.empty?
    asset.loads.each { |l| print "\n    #{Holly.get_symbol(l)}  #{l}" }
    
    print "\n\n  Full expansion:"
    asset.expanded.sources.each do |source|
      print "\n    #{source == asset.source ? "->" : Holly.get_symbol(source)}  #{source}"
    end
    
    print "\n\n  Referring files:"
    referring = asset.referring_assets
    print "\n        (none)" if referring.empty?
    referring.each do |asset|
      print "\n    #{Holly.get_symbol(asset.source)}  #{asset.source}"
    end
    
    print "\n\n  Dependants:"
    dependant = asset.dependant_assets
    print "\n        (none)" if dependant.empty?
    dependant.each do |asset|
      print "\n    #{Holly.get_symbol(asset.source)}  #{asset.source}"
    end
    
    print "\n"
  end
end
