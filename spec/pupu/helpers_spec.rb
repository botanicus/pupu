# encoding: utf-8

require_relative "../spec_helper"

require "pupu/pupu"
require "pupu/helpers"

describe "Helpers#pupu" do
  include Pupu::Helpers
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/root/pupu"
  end

  it "should return text with assets" do
    pupu(:autocompleter).should eql(Parser.new(:autocompleter).parse!)
  end

  it "should return text with assets" do
    pupu(:autocompleter, type: "local").should eql(Parser.new(:autocompleter, type: "local").parse!)
  end
end
