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
end
