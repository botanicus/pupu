module Merb
  module Plugins
    class DSL
      def initialize(plugin)
        @plugin = plugin
        @output = Array.new
      end

      def javascript(basename, params = Hash.new)
        path = @plugin.javascript(basename).url
        p path
        tag  = "<script src='#{path}' type='text/javascript'></script>"
        @output.push(tag)
      end

      def stylesheet(basename, params = Hash.new)
        path = @plugin.stylesheet(basename).url
        tag  = "<link href='#{path}' media='screen' rel='stylesheet' type='text/css' />"
        @output.push(tag)
      end

      def javascripts(*names)
        names.each do |name|
          self.javascript(name)
        end
      end

      def stylesheets(*names)
        names.each do |name|
          self.stylesheet(name)
        end
      end

      def parameter(name, params = Hash.new, &block)
        if @plugin.params.key?(name)
          block.call(@plugin.params[name])
        end
      end

      def output
        @output.join("\n")
      end
    end
  end
end
