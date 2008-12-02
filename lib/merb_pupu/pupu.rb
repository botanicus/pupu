require "merb_pupu/exceptions"

module Merb
  module Plugins
    class URL
      attr_reader :path
      # URL.new(Merb.root/public/pupu/autocompleter/javascripts/autocompleter.js)
      def initialize(path)
        raise AssetNotFound.new(path) unless File.exist?(path)
        @path = path.sub(%r{^(.*/)?(public/.+$)}, '\2')
      end

      def url
        @path.sub(/^public/, '')
      end

      def inspect
        %Q{#<Merb::Plugins::URL: @path="#{@path}" url="#{url}">}
      end
    end

    class Pupu
      class << self
        def all
          @entries ||= Dir["#{self.root}/*"].select do |item|
            File.directory?(item)
          end.map { |entry| File.basename(entry).to_s }
        end

        def root
          @root ||= File.join(Dir.pwd, "public", "pupu")
        end

        def root=(directory)
          @root = directory
          raise PupuRootNotFound unless File.exist?(@root)
          return @root
        end

        def [](plugin)
          plugin = plugin.to_s
          if self.all.include?(plugin)
            self.new(plugin)
          else
            raise PluginNotFoundError
          end
        end
      end

      def initialize(name, params = nil)
        @path   = name.to_s
        @params = params
      end

      def root
        @root ||= File.join(Dir.pwd, "public", "pupu", @path)
      end

      def public_root
        @public_root ||= File.join("/", "pupu", @path)
      end

      def javascript(basename)
        file("javascripts/#{basename}.js")
      end

      def stylesheet(basename)
        file("stylesheets/#{basename}.css")
      end

      def image(basename)
        file("javascripts/#{image}")
      end

      def uninstall
        # TODO
      end

      def initializer(type = :all)
        case type
        when :all
          [self.initializer(:javascript), self.initializer(:stylesheet)]
        when :javascript
          file("#{@path}.js", "/javascripts/initializers")
        when :stylesheet
          file("#{@path}.css", "/stylesheets/initializers")
        end
      end

      def file(path, root = self.root)
        URL.new(File.join(root, path))
      end
    end
  end
end
