require File.dirname(__FILE__) + '/spec_helper'
require "merb_pupu/exceptions"
include Merb::Plugins

describe PupuRootNotFound do
end

describe PluginNotFoundError do
end

describe AssetNotFound do
  it "should take one argument" do
    lambda { AssetNotFound.new("foo") }.should_not raise_error(ArgumentError)
  end
end
