require "merb_pupu/exceptions"
require "merb_pupu/metadata"
require "merb_pupu/url"

module Merb
  module Plugins
    class Pupu
      class << self
        # TODO: return Pupu object, not string
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

      attr_reader :params
      def initialize(name, params = Hash.new)
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
          file("#{@path}.js", "public/javascripts/initializers") rescue nil
        when :stylesheet
          file("#{@path}.css", "public/stylesheets/initializers") rescue nil
        end
      end

      def file(path, root = self.root)
        URL.new(File.join(root, path))
      end
    end
  end
end
