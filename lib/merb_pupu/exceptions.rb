module Merb
  module Pupu
    class PupuRootNotFound < StandardError
    end

    class PluginNotFoundError < StandardError
    end

    class PluginIsAlreadyInstalled < StandardError
    end

    class PublicDirNotExists < StandardError
    end

    class AssetNotFound < StandardError
      attr_accessor :path
      def initialize(path)
        @path = path
      end
    end
  end
end
