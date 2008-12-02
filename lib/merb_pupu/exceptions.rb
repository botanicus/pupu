module Merb
  module Plugins
    class PupuRootNotFound < StandardError
    end

    class PluginNotFoundError < StandardError
    end

    class AssetNotFound < StandardError
      def initialize(path)
      end
    end
  end
end
