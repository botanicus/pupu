require "merb_pupu/parser"

module Merb
  module Plugins
    module PupuHelpersMixin
      # Use it in your layout
      # Example: pupu :autocompleter, :type => "local"
      def pupu(name, params = nil)
        Parser.new(name, params).parse!
      end
    end
  end
end
