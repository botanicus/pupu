require "merb_pupu/dsl"
require "merb_pupu/pupu"

module Merb
  module Plugins
    class Parser
      def initialize(plugin_name, plugin_params)
        @plugin = Pupu.new(plugin_name, plugin_params) # TODO: what about Pupu[name, params]?
        @dsl    = DSL.new(@plugin)
      end

      def add_initializers
        js_initializer  = @plugin.initializer(:javascript)
        css_initializer = @plugin.initializer(:stylesheet)
        @output.push("<link href='#{css_initializer.path}' media='screen' rel='stylesheet' type='text/css' />") if css_initializer
        @output.push("<script src='#{js_initializer.path}' type='text/javascript'></script>") if js_initializer
      end

      def parse!
        @dsl.instance_eval(File.read(@plugin.file("config.rb").path))
        self.add_initializers
        return @dsl.output
      end
    end
  end
end
