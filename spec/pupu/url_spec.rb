require_relative "../spec_helper"
require "pupu/url"

describe Pupu::URL do
  before(:each) do
    @fullpath = "spec/data/public/pupu/autocompleter/javascripts/autocompleter.js"
    @relative = "data/public/pupu/autocompleter/javascripts/autocompleter.js"
    Pupu.root = File.dirname(__FILE__) + "/data/public/root/pupu"
    @url  = Pupu::URL.new(@fullpath)
  end

  describe "#initialize" do
    it "should raise AssetNotFound if given path do not exist" do
      lambda { Pupu::URL.new("i/do/not/exists") }.should raise_error(Pupu::AssetNotFound)
    end
  end

  describe "#path" do
    it "should be same as the path relative from current directory" do
      @url.path.should eql(@relative)
    end

    it "should cut the path to path relative from current directory" do
      path = "#{Dir.pwd}/spec/data/public/pupu/autocompleter/javascripts/autocompleter.js"
      url  = Pupu::URL.new(path)
      url.path.should eql(@relative) # yep, it still should be the same as @relative
    end
  end

  describe "#inspect" do
    it "should show @fullpath and url" do
      @url.inspect.should eql(%Q{#<URL: @path="#{@relative}" url="/pupu/autocompleter/javascripts/autocompleter.js">})
    end
  end
end
