require "pupu/exceptions"

module Pupu
  class URL
    attr_reader :path
    # URL.new(root/pupu/autocompleter/javascripts/autocompleter.js)
    # URL.new(Merb.root/root/pupu/autocompleter/javascripts/autocompleter.js)
    def initialize(path)
      path = File.expand_path(path).sub(%r[^#{Regexp::quote(Pupu::PROJECT_ROOT)}/], '')
      raise AssetNotFound.new(path) unless File.exist?(path)
      @path = path.sub(%r{^(.*/)?(root/.+$)}, '\2')
    end

    def url
      @path.sub(%r[^#{Regexp::quote(Pupu::MEDIA_DIRECTORY)}], '')
    end

    def inspect
      %Q{#<Pupu::URL: @path="#{@path}" url="#{url}">}
    end
  end
end
