require File.dirname(__FILE__) + '/spec_helper'
require "pupu/pupu"
require "pupu/helpers"
include Merb::Plugins
include Merb::Plugins::PupuHelpersMixin

describe "PupuHelpersMixin#pupu" do
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/public/pupu"
  end

  it "should return text with assets" do
    pupu(:autocompleter).should eql(Parser.new(:autocompleter).parse!)
  end

  it "should return text with assets" do
    pupu(:autocompleter, :type => "local").should eql(Parser.new(:autocompleter, :type => "local").parse!)
  end
end
