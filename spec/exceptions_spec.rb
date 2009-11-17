require File.dirname(__FILE__) + '/spec_helper'
require "pupu/exceptions"

describe Pupu::PupuRootNotFound do
end

describe Pupu::PluginNotFoundError do
end

describe Pupu::AssetNotFound do
  it "should take one argument" do
    lambda { AssetNotFound.new("foo") }.should_not raise_error(ArgumentError)
  end
end
