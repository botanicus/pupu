require "yaml"
require "ostruct"
require "pupu/exceptions"
require "pupu/metadata"
require "pupu/url"

module Pupu
  # this must be set in adapters
  class << self
    attr_accessor :root
    attr_accessor :media_root
    attr_accessor :media_prefix
  end

  class Pupu
    class << self
      # TODO: return Pupu object, not string
      def all
        Dir["#{self.root}/*"].select do |item|
          File.directory?(item)
        end.map { |entry| File.basename(entry).to_s }
      end

      def root(path = :absolute)
        # TODO: it should be configurable
        root = ::Pupu.root.sub(%r[#{Regexp::quote(::Pupu.root)}], '').chomp("/")
        # root = "./" if root.empty?
        case path
        when :absolute then File.join(root, ::Pupu.media_root, "pupu")
        when :relative then File.join(::Pupu.media_root, "pupu")
        else
          # exception
        end
      end

      # TODO: reflect changes on root method
      def root=(directory)
        @root = directory
        raise PupuRootNotFound unless File.exist?(@root)
        return @root
      end

      def [](plugin, params = Hash.new)
        plugin = plugin.to_s
        if self.all.include?(plugin)
          self.new(plugin, params)
        else
          raise PluginNotFoundError
        end
      end
    end

    attr_reader :name, :params
    def initialize(name, params = Hash.new)
      @name   = name.to_sym
      @path   = name.to_s
      @params = params
    end

    def root(path = :absolute)
      File.join(Pupu.root(path), @path)
    end

    def metadata
      OpenStruct.new(YAML::load_file(self.file("metadata.yml").path))
    end

    # TODO: change root to return URL and use URL#url
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
        file("#{@path}.js", "media/javascripts/initializers") rescue nil # TODO: fix media
      when :stylesheet
        file("#{@path}.css", "media/stylesheets/initializers") rescue nil # TODO: fix media
      end
    end

    def file(path, root = self.root)
      URL.new(File.join(root, path))
    end
  end
end
