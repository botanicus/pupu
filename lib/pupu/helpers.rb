# encoding: utf-8

require "pupu/parser"

module Pupu
  module Helpers
    def pupu_page
      @page ||= Page.new
    end

    # Use it in your layout
    # Example: pupu :autocompleter, type: "local"
    def pupu(name, params = Hash.new)
      comment = if params.empty? then "<!-- Pupu #{name} without params -->"
      else "<!-- Pupu #{name} with params #{params.inspect} -->" end
      [comment, pupu_page.parse(name, params).parse!, "", ""].join("\n")
    end
  end
end
