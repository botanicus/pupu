# encoding: utf-8

require_relative "../spec_helper"

require "pupu/pupu"

describe Pupu::Pupu do
  before(:each) do
    # Pupu.root = File.dirname(__FILE__) + "/data/root/pupu"
  end

  describe "[]" do
    it "should return Pupu::Pupu object" do
      Pupu::Pupu[:autocompleter].should be_kind_of(Pupu::Pupu)
    end

    it "should return nil if pupu do not exists" do
      lambda { Pupu::Pupu[:non_existing_pupu] }.should raise_error(Pupu::PluginNotFoundError)
    end
  end

  describe ".root=" do
    it "should return Pupu::Pupu object" do
      Pupu.root.should eql(PROJECT_ROOT)
    end

    it "should return nil if pupu do not exists" do
      lambda { Pupu.root = "#{PROJECT_ROOT}/root/prefix/pupu" }.should raise_error(Pupu::PupuRootNotFound)
    end
  end
  
  describe "#file" do
    it "should return path" do
      @pupu = Pupu::Pupu[:autocompleter]
      @pupu.file("autocompleter.js", @pupu.root + "/initializers").to_s.should eql("#{@pupu.root}/initializers/autocompleter.js")
    end
  end

  describe "#initializers(type)" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      @pupu.initializer.map{|path| path.to_s}.should eql(["#{Pupu.media_root}/pupu/autocompleter/initializers/autocompleter.js","#{Pupu.media_root}/pupu/autocompleter/initializers/autocompleter.css"])
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:javascript).to_s.should eql("#{Pupu.media_root}/pupu/autocompleter/initializers/autocompleter.js")
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:stylesheet).to_s.should eql("#{Pupu.media_root}/pupu/autocompleter/initializers/autocompleter.css")
    end

    it "should raise error for non-existing initializer type" do
      lambda { @pupu.initializer(:nonexisting) }.should raise_error()
    end

    it "should raise AssetNotFound if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(Pupu::AssetNotFound)
    end
  end

  # initializer.js will be copied into root/javascripts/initializers/[pupu-name].js
  describe "#copy_initializers" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      pending "#copy_initializers is not implemented yet"
      @pupu.initializer.should eql("#{PROJECT_ROOT}/root/pupu/autocompleter/initializer.js")
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(Pupu::AssetNotFound)
    end
  end

  describe "#uninstall" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return path to image" do
      pending
      @pupu.uninstall # TODO
    end

    it "should return nil if image do not exists" do
      pending
      lambda { @pupu.image("missing.gif") }.should raise_error(Pupu::AssetNotFound) # TODO
    end
  end

  describe "#image" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.image("spinner.gif").to_s.should eql("#{Pupu.media_root}/pupu/autocompleter/images/spinner.gif")
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise_error(Pupu::AssetNotFound)
    end
  end

  describe "#javascript" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return path to javascript" do
      @pupu.javascript("autocompleter").to_s.should eql("#{Pupu.media_root}/pupu/autocompleter/javascripts/autocompleter.js")
    end

    it "should return nil if javascript do not exists" do
      lambda { @pupu.javascript("missing") }.should raise_error(Pupu::AssetNotFound)
    end
  end

  describe "#stylesheet" do
    before(:each) do
      @pupu = Pupu::Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.stylesheet("autocompleter").to_s.should eql("#{Pupu.media_root}/pupu/autocompleter/stylesheets/autocompleter.css")
    end

    it "should return nil if stylesheet do not exists" do
      lambda { @pupu.stylesheet("missing") }.should raise_error(Pupu::AssetNotFound)
    end
  end
end
