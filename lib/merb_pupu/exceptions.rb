module Merb
  module Plugins
    class PupuRootNotFound < StandardError
    end

    class PluginNotFoundError < StandardError
    end

    class AssetNotFound < StandardError
      attr_accessor :path
      def initialize(path)
        @path = path
      end
    end
  end
end
