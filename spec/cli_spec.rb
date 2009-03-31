require File.dirname(__FILE__) + '/spec_helper'
require "pupu/cli"
include Merb::Plugins

describe Pupu do
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/public/pupu"
    Merb.stub!(:root).and_return(File.dirname(__FILE__) + "/data")
  end

  describe ".depends_on" do
    it "should return Pupu object" do
      Pupu.depends_on(:autocompleter).should # TODO
    end

    it "should return nil if pupu do not exists" do
      Pupu.depends_on(:autocompleter).should # TODO
    end
  end
end
