require File.dirname(__FILE__) + '/spec_helper'
require "merb_pupu/helpers"
include Merb::Plugins

describe PupuHelpersMixin do
  describe "plugin" do
    it "should return Plugin object" do
      plugin(:autocompleter)
    end

    it "should return Plugin object" do
      lambda { plugin(:autocompleter) }.should raise
    end

    it "should return nil if plugin do not exists" do
      plugin(:autocompleter, :request => "local")
    end
  end
end
