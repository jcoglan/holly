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
      assert_equal '/javascripts/prototype.js', Holly::ScriptFile.new(source).source
    end
    
    assert_equal '/prototype.js', Holly::ScriptFile.new('/prototype').source
    
    [
      'http://svn.jcoglan.com/something.js',
      'http://svn.jcoglan.com/something'
    ].each do |source|
      assert_equal 'http://svn.jcoglan.com/something.js', Holly::ScriptFile.new(source).source
    end
    
    assert_equal('http://svn.jcoglan.com/something.js?id=foo.js',
        Holly::ScriptFile.new('http://svn.jcoglan.com/something.js?id=foo').source)
  end
  
  def test_logger
    log = Holly::Logger.new
    log.log('prototype.js?1199484190', '/javascripts/prototype')
    assert log.rendered?('/javascripts/prototype.js')
    assert_equal 1, log.sources.size
  end
  
  def test_requires
    assert Holly::ScriptFile.new("prototype").requires.empty?
    effects = Holly::ScriptFile.new("effects")
    assert_equal 2, effects.requires.size
    assert_equal '/javascripts/prototype.js', effects.requires[0]
    assert_equal 'http://yui.yahooapis.com/2.4.1/build/yahoo-dom-event/yahoo-dom-event.js', effects.requires[1]
    dragdrop = Holly::ScriptFile.new("dragdrop")
    assert_equal 1, dragdrop.requires.size
    assert_equal '/javascripts/effects.js', dragdrop.requires[0]
  end
  
  def test_loads
    assert Holly::ScriptFile.new("prototype").loads.empty?
    assert Holly::ScriptFile.new("dragdrop").loads.empty?
    effects = Holly::ScriptFile.new("effects")
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
    assert_equal scripts, Holly::ScriptFile::Collection.new('dragdrop').to_a
    assert_equal scripts, Holly::ScriptFile::Collection.new('/javascripts/dragdrop.js').to_a
    assert_equal scripts, Holly::ScriptFile::Collection.new('prototype', 'dragdrop').to_a
    assert_equal scripts, Holly::ScriptFile::Collection.new('effects').to_a
  end
end
