require "yaml"
require "ostruct"
require "path"
require "pupu/exceptions"
require "pupu/metadata"

module Pupu
  # this must be set in adapters
  class << self
    attr_accessor :root

    # @example Pupu.media_prefix("media").url
    #   => "/media/pupu/autocompleter/javascripts/autocompleter.js"
    def media_prefix=(prefix)
      Path.rewrite { |path| File.join(prefix, path) }
    end

    # TODO: media_root or media_directory?
    def media_root=(path)
      Path.media_directory = path
      @media_root = path
    end
    attr_reader :media_root

    # @example Pupu.rewrite { |path| "http://media.domain.org/#{path}" }.url
    #   # => "http://media.domain.org/pupu/autocompleter/javascripts/autocompleter.js"
    def rewrite(&block)
      Path.rewrite(&block)
    end
  end

  class Pupu
    class << self
      # TODO: return Pupu object, not string
      def all
        Dir["#{self.root}/*"].select do |item|
          File.directory?(item)
        end.map { |entry| File.basename(entry).to_s }
      end

      def root
        # TODO: it should be configurable
        # root = ::Pupu.root.sub(%r[#{Regexp::quote(::Pupu.root)}], '').chomp("/")
        # root = "./" if root.empty?
        # case path
        #  when :absolute then File.join(root, ::Pupu.media_root, "pupu")
        #  when :relative then File.join(::Pupu.media_root, "pupu")
        #  else
        #    # exception
        #  end
        @root ||= Path.new(File.join(::Pupu.media_root, "pupu"))
      end

      # TODO: reflect changes on root method
      def root=(directory)
        @root = Path.new(directory)
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

    def root
      self.class.root.join(@path)
    end

    def metadata
      OpenStruct.new(YAML::load_file(self.file("metadata.yml").path))
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
      root.join(path)
    end
  end
end
