$holly_test_path = File.dirname(__FILE__) + '/assets'

require 'test/unit'
require File.dirname(__FILE__) + '/../../../../config/environment'

class HollyTest < Test::Unit::TestCase
  
  def test_javascript_paths
    {
      'prototype'                       => '/javascripts/prototype.js',
      'prototype.js'                    => '/javascripts/prototype.js',
      'prototype.js?34737'              => '/javascripts/prototype.js',
      '/prototype'                      => '/prototype.js',
      '/prototype.js'                   => '/prototype.js',
      '/prototype.rb'                   => '/prototype.rb',
      '/stylesheets/style'              => '/stylesheets/style.css',
      '/stylesheets/style.css'          => '/stylesheets/style.css',
      '/stylesheets/style.js'           => '/stylesheets/style.js',
      'http://svn.jcoglan.com/foo'      => 'http://svn.jcoglan.com/foo.js',
      'http://svn.jcoglan.com/foo.css'  => 'http://svn.jcoglan.com/foo.css'
    }.each do |source, path|
      assert_equal path, Holly.resolve_source(source, "js")
    end
  end
  
  def test_stylesheet_paths
    {
      'style'                           => '/stylesheets/style.css',
      'style.css'                       => '/stylesheets/style.css',
      'style.css?34737'                 => '/stylesheets/style.css',
      '/style'                          => '/style.css',
      '/style.css'                      => '/style.css',
      '/style.rb'                       => '/style.rb',
      '/javascripts/script'             => '/javascripts/script.js',
      '/javascripts/script.css'         => '/javascripts/script.css',
      '/javascripts/script.js'          => '/javascripts/script.js',
      'http://svn.jcoglan.com/foo'      => 'http://svn.jcoglan.com/foo.css',
      'http://svn.jcoglan.com/foo.js'   => 'http://svn.jcoglan.com/foo.js'
    }.each do |source, path|
      assert_equal path, Holly.resolve_source(source, "css")
    end
  end
  
  def test_logger
    log = Holly::Logger.new
    log.log('prototype.js?1199484190', '/javascripts/prototype')
    assert log.rendered?('/javascripts/prototype.js')
    assert_equal 1, log.sources.size
  end
  
  def test_requires
    assert Holly::Asset.new("prototype").requires.empty?
    effects = Holly::Asset.new("effects")
    assert_equal 2, effects.requires.size
    assert_equal '/javascripts/prototype.js', effects.requires[0]
    assert_equal 'http://yui.yahooapis.com/2.4.1/build/yahoo-dom-event/yahoo-dom-event.js', effects.requires[1]
    dragdrop = Holly::Asset.new("dragdrop")
    assert_equal 1, dragdrop.requires.size
    assert_equal '/javascripts/effects.js', dragdrop.requires[0]
  end
  
  def test_loads
    assert Holly::Asset.new("prototype").loads.empty?
    assert Holly::Asset.new("dragdrop").loads.empty?
    effects = Holly::Asset.new("effects")
    assert_equal 1, effects.loads.size
    assert_equal '/javascripts/dragdrop.js', effects.loads[0]
  end
  
  def test_expanding
    scripts = [
      '/javascripts/prototype.js',
      'http://yui.yahooapis.com/2.4.1/build/yahoo-dom-event/yahoo-dom-event.js',
      '/javascripts/effects.js',
      '/javascripts/dragdrop.js'
    ]
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop').to_a
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', 'dragdrop.js').to_a
    assert_equal scripts, Holly::Asset::Collection.new('/javascripts/dragdrop.js').to_a
    assert_equal scripts, Holly::Asset::Collection.new('prototype', 'dragdrop').to_a
    assert_equal scripts, Holly::Asset::Collection.new('effects').to_a
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', '/javascripts/prototype', 'effects').to_a
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', 'effects').to_a
    assert_equal scripts, Holly::Asset::Collection.new('effects', 'prototype').to_a
  end
end
