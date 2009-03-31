require "pupu/exceptions"

module Pupu
  class URL
    attr_reader :path
    # URL.new(public/pupu/autocompleter/javascripts/autocompleter.js)
    # URL.new(Merb.root/public/pupu/autocompleter/javascripts/autocompleter.js)
    def initialize(path)
      raise AssetNotFound.new(path) unless File.exist?(path)
      @path = path.sub(%r{^(.*/)?(public/.+$)}, '\2')
    end

    def url
      @path.sub(/^public/, '')
    end

    def inspect
      %Q{#<Pupu::URL: @path="#{@path}" url="#{url}">}
    end
  end
end
