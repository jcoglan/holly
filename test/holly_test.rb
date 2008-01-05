$holly_test_path = File.dirname(__FILE__) + '/assets'

require 'test/unit'
require File.dirname(__FILE__) + '/../../../../config/environment'

class HollyTest < Test::Unit::TestCase
  
  def test_source_conversion
    [
      'prototype',
      'prototype.js',
      'prototype.js?1199484190',
      '/javascripts/prototype.js?1199484190',
      '/javascripts/prototype',
      '/javascripts/prototype.js'
    ].each do |source|
      assert_equal '/javascripts/prototype.js', Holly.resolve_source(source)
    end
    
    assert_equal '/prototype.js', Holly.resolve_source('/prototype')
    
    [
      'http://svn.jcoglan.com/something.js',
      'http://svn.jcoglan.com/something'
    ].each do |source|
      assert_equal 'http://svn.jcoglan.com/something.js', Holly.resolve_source(source)
    end
    
    assert_equal 'http://svn.jcoglan.com/something.js?id=foo.js',
        Holly.resolve_source('http://svn.jcoglan.com/something.js?id=foo')
    
    [
      'style.css',
      '/stylesheets/style',
      'style.css?3457356',
      '/stylesheets/style?735746',
      '/stylesheets/style.css?735746'
    ].each do |source|
      assert_equal '/stylesheets/style.css', Holly.resolve_source(source)
    end
    
    assert_equal '/javascripts/style.css', Holly.resolve_source('/javascripts/style', 'css')
    assert_equal '/javascripts/style.js', Holly.resolve_source('/javascripts/style')
    assert_equal '/stylesheets/script.js', Holly.resolve_source('/stylesheets/script', 'js')
    assert_equal '/stylesheets/script.css', Holly.resolve_source('/stylesheets/script')
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
