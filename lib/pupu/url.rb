require "pupu/exceptions"

module Pupu
  class URL
    attr_reader :path
    # URL.new(root/pupu/autocompleter/javascripts/autocompleter.js)
    # URL.new(Merb.root/root/pupu/autocompleter/javascripts/autocompleter.js)
    def initialize(path)
      path = File.expand_path(path).sub(%r[^#{Regexp::quote(::Pupu.root)}/], '')
      raise AssetNotFound.new(path) unless File.exist?(path)
      @path = path.sub(%r{^(.*/)?(root/.+$)}, '\2')
    end

    def url
      url = @path.sub(%r[^#{Regexp::quote(::Pupu.media_root)}], Regexp::quote(::Pupu.media_prefix))
      "/#{url}"
    end

    def inspect
      %Q{#<Pupu::URL: @path="#{@path}" url="#{url}">}
    end
  end
end
