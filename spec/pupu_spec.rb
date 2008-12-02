require File.dirname(__FILE__) + '/spec_helper'

describe Pupu do
  describe "[]" do
    it "should return Pupu object" do
      Pupu[:autocompleter].should be_kind_of(Pupu)
    end

    it "should return nil if pupu do not exists" do
      Pupu[:non_existing_pupu].should be_nil # TODO: exceptionf
    end
  end

  describe ".root=" do
    it "should return Pupu object" do
      Pupu.root.should eql(Merb.root/"public/pupu")
    end

    it "should return nil if pupu do not exists" do
      Pupu.root = Merb.root/"public/prefix/pupu"
      Pupu.root.should eql(Merb.root/"public/prefix/pupu")
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
      @pupu.create! # TODO
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError) # TODO
    end
  end

  # TODO: something similar for css ... initializers?
  describe "#initializers(type)" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      @pupu.initializer.should eql(Merb.root/"public/pupu/autocompleter/initializer.js") # TODO: pole s 2 pathname
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:script).should eql(Merb.root/"public/pupu/autocompleter/initializer.js")
    end

    it "should return pathname to pupu" do
      @pupu.initializer(:stylesheet).should eql(Merb.root/"public/pupu/autocompleter/initializer.css")
    end

    it "should return pathname to pupu" do
      lambda { @pupu.initializer(:nonexisting) }.should raise()
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError) # TODO
    end
  end

  # initializer.js will be copied into public/javascripts/initializers/[pupu-name].js
  describe "#copy_initializers" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return pathname to pupu" do
      @pupu.initializer.should eql(Merb.root/"public/pupu/autocompleter/initializer.js")
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError) # TODO
    end
  end

  describe "#create!" do
    before(:each) do
      #@pupu = Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.create! # TODO
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError) # TODO
    end
  end

  describe "#destroy!" do
    before(:each) do
      #@pupu = Pupu[:autocompleter]
    end

    it "should return path to image" do
      @pupu.destroy! # TODO
    end

    it "should return nil if image do not exists" do
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError) # TODO
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
      lambda { @pupu.image("missing.gif") }.should raise(MissingImageError)
    end
  end

  describe "#script" do
    before(:each) do
      @pupu = Pupu[:autocompleter]
    end

    it "should return path to script" do
      @pupu.script("autocompleter").should eql("/pupu/autocompleter/lib/autocompleter.js")
    end

    it "should return nil if script do not exists" do
      lambda { @pupu.script("missing") }.should raise(MissingScriptError)
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
      lambda { @pupu.stylesheet("missing") }.should raise(MissingStylesheetError)
    end
  end
end
