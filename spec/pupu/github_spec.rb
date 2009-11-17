require File.dirname(__FILE__) + '/spec_helper'
require "pupu/github"

# TODO
describe Pupu::GitHub do
  describe "plugin" do
    it "should return Plugin object" do
      plugin(:autocompleter)
    end

    it "should return Plugin object" do
      lambda { plugin(:autocompleter) }.should raise_error
    end

    it "should return nil if plugin do not exists" do
      plugin(:autocompleter, :request => "local")
    end
  end
end
