require File.dirname(__FILE__) + '/spec_helper'
require "pupu/url"
include Merb::Plugins

describe URL do
  before(:each) do
    @fullpath = "spec/data/public/pupu/autocompleter/javascripts/autocompleter.js"
    @relative = "public/pupu/autocompleter/javascripts/autocompleter.js"
    @url  = URL.new(@fullpath)
  end

  describe "#initialize" do
    it "should raise AssetNotFound if given path do not exist" do
      lambda { URL.new("i/do/not/exists") }.should raise_error(AssetNotFound)
    end
  end

  describe "#path" do
    it "should be same as the path relative from current directory" do
      @url.path.should eql(@relative)
    end

    it "should cut the path to path relative from current directory" do
      path = "#{Dir.pwd}/spec/data/public/pupu/autocompleter/javascripts/autocompleter.js"
      url  = URL.new(path)
      url.path.should eql(@relative) # yep, it still should be the same as @relative
    end
  end

  describe "#inspect" do
    it "should show @fullpath and url" do
      @url.inspect.should eql(%Q{#<Merb::Plugins::URL: @path="#{@relative}" url="/pupu/autocompleter/javascripts/autocompleter.js">})
    end
  end
end
