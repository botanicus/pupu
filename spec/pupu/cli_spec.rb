require_relative "../spec_helper"
require "pupu/cli"

describe Pupu do
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/root/pupu"
    @root = File.dirname(__FILE__) + "/data"
  end

  describe ".depends_on" do
    it "should return Pupu object" do
      pending "Implement depends_on"
      Pupu.depends_on(:autocompleter).should # TODO
    end

    it "should return nil if pupu do not exists" do
      pending "Implement depends_on"
      Pupu.depends_on(:autocompleter).should # TODO
    end
  end
end
