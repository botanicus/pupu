require "yaml"
require "ostruct"
require "pupu/exceptions"
require "pupu/metadata"
require "pupu/url"

module Pupu
  class Pupu
    class << self
      ROOT = Dir.pwd # must be initialized at start, otherwise Pupu.root can return bad values when it's called in Dir.chdir block
      # TODO: return Pupu object, not string
      def all
        Dir["#{self.root}/*"].select do |item|
          File.directory?(item)
        end.map { |entry| File.basename(entry).to_s }
      end

      def root(path = :absolute)
        case path
        when :absolute then "#{ROOT}/public/pupu"
        when :relative then "public/pupu"
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

    # TODO: reflect changes on root method
    def root(path = :absolute)
      case path
      when :absolute then File.join(Pupu.root(:absolute), @path)
      when :relative then File.join(Pupu.root(:relative), @path)
      else
        # exception
      end
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
