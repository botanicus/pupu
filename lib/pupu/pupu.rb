# encoding: utf-8

require "yaml"
require "ostruct"
require "fileutils"
require "media-path"
require "pupu/exceptions"
require "pupu/metadata"

module Pupu
  # this must be set in adapters
  def self.root
    @@root ||= Dir.pwd
  end

  def self.root=(path)
    raise PupuRootNotFound unless File.directory?(path)
    @@root = path
  end

  def self.framework
    @@framework
  end

  def self.framework=(framework)
    @@framework = framework
  end

  def self.environment?(environment)
    self.environment.eql?(environment)
  end

  # @example Pupu.media_prefix("media").url
  #   => "/media/pupu/autocompleter/javascripts/autocompleter.js"
  def self.media_prefix=(prefix)
    MediaPath.rewrite { |path| File.join(prefix, path) }
  end

  def self.media_root
    @@media_root ||= Dir.pwd
  end

  def self.media_root=(path)
    MediaPath.media_root = path
    @@media_root = path
  end

  # @example Pupu.rewrite { |path| "http://media.domain.org/#{path}" }.url
  #   # => "http://media.domain.org/pupu/autocompleter/javascripts/autocompleter.js"
  def rewrite(&block)
    MediaPath.rewrite(&block)
  end

  # strategies: submodules, copy
  def self.strategy
    @@strategy ||= :copy
  end

  def self.strategy=(strategy)
    @@strategy = strategy
  end

  class Pupu
    class << self
      # TODO: return Pupu object, not string
      def all
        files = Dir["#{self.root_path}/*"]
        dirs = files.select(&File.method(:directory?))
        dirs.map(&File.method(:basename))
      end

      # same as root, but doesn't raise any exception
      def root_path
        File.join(::Pupu.media_root, "pupu")
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
        raise "Pupu.media_root has to be initialized" if ::Pupu.media_root.nil?
        raise Errno::ENOENT, "#{self.root_path} doesn't exist, you have to create it first!" unless File.directory?(self.root_path)
        @root ||= MediaPath.new(self.root_path)
      end

      # TODO: reflect changes on root method
      def root=(directory)
        @root = MediaPath.new(directory)
        raise PupuRootNotFound unless File.exist?(@root.to_s)
        return @root
      end

      def [](plugin, params = Hash.new)
        plugin = plugin.to_s
        if self.all.include?(plugin)
          self.new(plugin, params)
        else
          raise PluginNotFoundError.new(plugin)
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
      # self.class.root.join(@path)
      File.join(self.class.root_path, @path)
    end

    def metadata
      return @metadata if @metadata
      path = self.file("metadata.yml").path
      hash = YAML::load_file(path)
      @metadata = OpenStruct.new(hash)
      @metadata.repository ||= @metadata.repozitory   # temporary hack for old style metadata.yml
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
      file("images/#{basename}")
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
        file("#{@path}.js", "#{root}/initializers") rescue nil # TODO: fix media
      when :stylesheet
        file("#{@path}.css", "#{root}/initializers") rescue nil # TODO: fix media
      else
        raise Exception, "#{type.to_s} is not know type of initializer"
      end
    end
    
    def copy_initializers
      js_initializer = initializer(:javascript)
      css_initializer = initializer(:stylesheet)
      
      if js_initializer && (not File.exist?("#{::Pupu.media_root}/javascripts/initializers/#{File.basename(js_initializer.to_s)}"))
        FileUtils.mkdir_p("#{::Pupu.media_root}/javascripts/initializers")
        FileUtils.mv js_initializer.to_s, "#{::Pupu.media_root}/javascripts/initializers/#{File.basename(js_initializer.to_s)}"
      end
      
      if css_initializer && (not File.exist?("#{::Pupu.media_root}/stylesheets/initializers/#{File.basename(css_initializer.to_s)}"))
        FileUtils.mkdir_p("#{::Pupu.media_root}/stylesheets/initializers")
        FileUtils.mv css_initializer.to_s, "#{::Pupu.media_root}/stylesheets/initializers/#{File.basename(css_initializer.to_s)}"
      end
    end

    def soft_file(path, root = self.root)
      File.join(root.to_s, path.to_s) # for files which doesn't exist so far
    end

    def file(path, root = self.root)
      root = MediaPath.new(root) if root.is_a?(String)
      root.join(path)
    rescue Errno::ENOENT
      raise AssetNotFound, "#{soft_file(path, root)}"
    end
  end
end
