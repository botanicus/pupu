# encoding: utf-8

require_relative "../spec_helper"

require "pupu/parser"

# TODO
describe Pupu::Parser do
  describe "plugin" do
    it "should return Plugin object" do
      plugin(:autocompleter)
    end

    it "should return Plugin object" do
      lambda { plugin(:autocompleter) }.should raise
    end

    it "should return nil if plugin do not exists" do
      plugin(:autocompleter, request: "local")
    end
  end
end
