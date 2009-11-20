require "yaml"
require "ostruct"
require "fileutils"
require "media-path"
require "pupu/exceptions"
require "pupu/metadata"

module Pupu
  # this must be set in adapters
  class << self
    attr_accessor :root

    # @example Pupu.media_prefix("media").url
    #   => "/media/pupu/autocompleter/javascripts/autocompleter.js"
    def media_prefix=(prefix)
      MediaPath.rewrite { |path| File.join(prefix, path) }
    end

    # TODO: media_root or media_root?
    def media_root=(path)
      MediaPath.media_root = path
      @media_root = path
    end
    attr_reader :media_root

    # @example Pupu.rewrite { |path| "http://media.domain.org/#{path}" }.url
    #   # => "http://media.domain.org/pupu/autocompleter/javascripts/autocompleter.js"
    def rewrite(&block)
      MediaPath.rewrite(&block)
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

      # same as root, but doesn't raise any exception
      def root_path
        File.join(::Pupu.media_root, "pupu")
      end

      # strategies: submodules, copy
      cattr_accessor :strategy
      self.strategy = :copy

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
        raise "Pupu.media_root has to be initialized" if ::Pupu.media_root.nil?
        raise Errno::ENOENT, "#{::Pupu.media_root}/pupu doesn't exist, you have to create it first!" unless File.directory?File.join(::Pupu.media_root, "pupu")
        @root ||= MediaPath.new(File.join(::Pupu.media_root, "pupu"))
      end

      # TODO: reflect changes on root method
      def root=(directory)
        @root = MediaPath.new(directory)
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
      @metadata = OpenStruct.new(YAML::load_file(self.file("metadata.yml").path))
    rescue Errno::ENOENT # we might remove pupu directory, so metadata are missing, but we can get them from cache
      @metadata
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
      FileUtils.rm_r self.root.to_s
      # TODO
      # self.metadata.dependants.each do |dependant|
      #   dependant.uninstall
      # end
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
