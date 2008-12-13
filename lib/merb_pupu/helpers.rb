require "merb_pupu/parser"

module Merb
  module Pupu
    module PupuHelpersMixin
      # Use it in your layout
      # Example: pupu :autocompleter, :type => "local"
      def pupu(name, params = Hash.new)
        comment = if params.empty? then "<!-- Pupu #{name} without params -->"
        else "<!-- Pupu #{name} with params #{params.inspect} -->" end
        [comment, Parser.new(name, params).parse!, "", ""].join("\n")
      end
    end
  end
end
