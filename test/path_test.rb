# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/test_helper')

describe Amara::Path do

  it "returns a path api object" do
    amara = Amara::Client.new
    assert_equal amara.path('some/path').class, Amara::Path
  end

  it "raises an exception if no path is passed" do
    amara = Amara::Client.new
    assert_raises ArgumentError do
      amara.path.wont_be_nil
    end
  end

  it "sets the custom path" do
    amara = Amara::Client.new
    path = amara.path('some/path')
    assert_equal 'some/path', path.current_options['path']
  end
end
