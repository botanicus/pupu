require File.dirname(__FILE__) + '/spec_helper'
require "merb_pupu/pupu"
include Merb::Plugins

describe Pupu do
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/public/pupu"
    Merb.stub!(:root).and_return(File.dirname(__FILE__) + "/data")
  end

  describe "[]" do
    it "should return Pupu object" do
      Pupu[:autocompleter].should be_kind_of(Pupu)
    end

    it "should return nil if pupu do not exists" do
      lambda { Pupu[:non_existing_pupu] }.should raise_error(PluginNotFoundError)
    end
  end

  describe ".root=" do
    it "should return Pupu object" do
      Pupu.root.should eql("#{Merb.root}/public/pupu")
    end

    it "should return nil if pupu do not exists" do
      lambda { Pupu.root = "#{Merb.root}/public/prefix/pupu" }.should raise_error(PupuRootNotFound)
    end
  end

  describe ".depends_on" do
    it "should return Pupu object" do
      Pupu.depends_on(:autocompleter).should # TODO
    end

    it "should return nil if pupu do not exists" do
      Pupu.depends_on(:autocompleter).should # TODO
    end
  end

  describe "#pathname" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(AssetNotFound) # TODO
    end
  end

  describe "#initializers(type)" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      @pupu.initializer.should eql("#{Merb.root}/public/pupu/autocompleter/initializer.js") # TODO: pole s 2 pathname
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:script).should eql("#{Merb.root}/public/pupu/autocompleter/initializer.js")
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:stylesheet).should eql("#{Merb.root}/public/pupu/autocompleter/initializer.css")
    end

    it "should return pathname to pupu" do
      lambda { @pupu.initializer(:nonexisting) }.should raise_error()
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(AssetNotFound) # TODO
    end
  end

  # initializer.js will be copied into public/javascripts/initializers/[pupu-name].js
  describe "#copy_initializers" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      @pupu.initializer.should eql("#{Merb.root}/public/pupu/autocompleter/initializer.js")
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(AssetNotFound) # TODO
    end
  end

  describe "#uninstall" do
    before(:each) do
      #@pupu = Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.uninstall # TODO
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(AssetNotFound) # TODO
    end
  end

  describe "#image" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.image("spinner.gif").should eql("/pupu/autocompleter/images/spinner.gif")
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(AssetNotFound)
    end
  end

  describe "#javascript" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return path to javascript" do
      @pupu.javascript("autocompleter").should eql("/pupu/autocompleter/lib/autocompleter.js")
    end

    it "should return nil if javascript do not exists" do
      lambda { @pupu.javascript("missing") }.should raise_error(AssetNotFound)
    end
  end

  describe "#stylesheet" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.stylesheet("autocompleter").should eql("/pupu/autocompleter/autocompleter.css")
    end

    it "should return nil if stylesheet do not exists" do
      lambda { @pupu.stylesheet("missing") }.should raise_error(AssetNotFound)
    end
  end
end
