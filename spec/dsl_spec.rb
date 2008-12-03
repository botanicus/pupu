require File.dirname(__FILE__) + '/spec_helper'
require "merb_pupu/dsl"
require "merb_pupu/pupu"
include Merb::Plugins

describe DSL do
  before(:each) do
    Pupu.root = File.dirname(__FILE__) + "/data/public/pupu"
    @plugin = Pupu.new(:autocompleter)
    @dsl    = DSL.new(@plugin)
  end

  describe "#javascript" do
    it "should return <script> tag with correct src attribute" do
      src = @plugin.javascript("autocompleter").url
      @dsl.javascript("autocompleter")
      @dsl.output.should eql("<script src='#{src}' type='text/javascript'></script>")
    end
  end

  describe "#stylesheet" do
    it "should return <link> tag with correct src attribute" do
      path = @plugin.stylesheet("autocompleter").url
      @dsl.stylesheet("autocompleter")
      @dsl.output.should eql("<link href='#{path}' media='screen' rel='stylesheet' type='text/css' />")
    end
  end

  # TODO
  describe "#javascripts" do
    it "should return <script> tag with correct src attribute" do
      src = @plugin.javascripts("autocompleter").url
      @dsl.javascripts("autocompleter")
      @dsl.output.scan(/#{Regexp::quote(src)}/).length.should eql(3)
    end
  end

  # TODO
  describe "#stylesheets" do
    it "should return <link> tag with correct src attribute" do
      path = @plugin.stylesheets("autocompleter").url
      @dsl.stylesheets("autocompleter")
      @dsl.output.scan(/#{Regexp::quote(path)}/).length.should eql(3)
    end
  end

  # TODO
  describe "#parameter" do
    it "" do
    end
  end

  describe "#output" do
    it "should return string" do
      @dsl.output.should be_kind_of(String)
    end

    it "should have one item per line" do
      @dsl.javascripts("autocompleter", "autocompleter.local", "autocompleter.request")
      @dsl.output.split("\n").length.should eql(3)
    end
  end
end
