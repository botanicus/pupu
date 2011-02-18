# encoding: utf-8

module Pupu
  class PupuRootNotFound < StandardError
  end

  class PluginNotFoundError < StandardError
    def initialize(plugin)
      super("Plugin not found: #{plugin.inspect}")
    end
  end

  class PluginIsAlreadyInstalled < StandardError
  end

  class MediaDirectoryNotExist < StandardError
  end

  class AssetNotFound < StandardError
    attr_accessor :path, :message
    def initialize(path)
      @path = path
      @message = "File #{@path} doesn't exist."
    end
  end
end
