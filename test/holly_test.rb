$holly_test_path = File.dirname(__FILE__) + '/assets'

require 'test/unit'
require File.dirname(__FILE__) + '/../../../../config/environment'

class HollyTest < Test::Unit::TestCase
  
  JS_FILES = {
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
  }
  
  CSS_FILES = {
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
  }
  
  def test_javascript_paths
    JS_FILES.each do |source, path|
      assert_equal path, Holly.resolve_source(source, "js")
    end
  end
  
  def test_stylesheet_paths
    CSS_FILES.each do |source, path|
      assert_equal path, Holly.resolve_source(source, "css")
    end
  end
  
  def test_js_requires
    js = Holly::Asset.new('script.js')
    assert_equal JS_FILES.values.sort, js.requires.sort
  end
  
  def test_css_loads
    css = Holly::Asset.new('style.css')
    assert_equal CSS_FILES.values.sort, css.loads.sort
  end
  
  def test_expanding
    scripts = [
      '/javascripts/prototype.js',
      'http://yui.yahooapis.com/2.4.1/build/yahoo-dom-event/yahoo-dom-event.js',
      '/javascripts/effects.js',
      '/javascripts/dragdrop.js'
    ]
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop').sources
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', 'dragdrop.js').sources
    assert_equal scripts, Holly::Asset::Collection.new('/javascripts/dragdrop.js').sources
    assert_equal scripts, Holly::Asset::Collection.new('prototype', 'dragdrop').sources
    assert_equal scripts, Holly::Asset::Collection.new('effects').sources
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', '/javascripts/prototype', 'effects').sources
    assert_equal scripts, Holly::Asset::Collection.new('dragdrop', 'effects').sources
    assert_equal scripts, Holly::Asset::Collection.new('effects', 'prototype').sources
    
    widget = [
      '/javascripts/prototype.js',
      'http://yui.yahooapis.com/2.4.1/build/yahoo-dom-event/yahoo-dom-event.js',
      '/javascripts/effects.js',
      '/javascripts/dragdrop.js',
      '/widget.js',
      '/widget/item.js',
      '/stylesheets/widget.css'
    ]
    
    assert_equal widget, Holly::Asset::Collection.new('/widget.js').sources
  end
  
  def test_ordering
    assert_equal [
      '/stylesheets/gallery/item.css',
      '/stylesheets/foo.css'
    ], Holly::Asset::Collection.new('foo.css').sources
    
    assert_equal [
      '/stylesheets/bar.css',
      '/stylesheets/gallery.css',
      '/stylesheets/gallery/item.css',
      '/stylesheets/gallery/container.css',
      '/stylesheets/gallery/page.css'
    ], Holly::Asset::Collection.new('bar.css').sources
  end
  
  def test_logger
    log = Holly::Logger.new
    log.log('prototype.js?1199484190', '/javascripts/prototype')
    assert log.rendered?('/javascripts/prototype.js')
    assert_equal 1, log.sources.size
  end
end
