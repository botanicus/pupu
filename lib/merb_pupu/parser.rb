require "merb_pupu/dsl"
require "merb_pupu/pupu"

module Merb
  module Plugins
    class Parser
      def initialize(plugin_name, plugin_params)
        @plugin = Pupu.new(plugin_name, plugin_params)
        @dsl    = DSL.new(@plugin)
      end

      def parse!
        @dsl.instance_eval(File.read(@plugin.file("config.rb").path))
        return @dsl.output
      end
    end
  end
end
