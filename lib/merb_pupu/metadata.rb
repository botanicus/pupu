module Merb
  module Plugins
    class Metadata
      def load
        Pupu.all.each do |pupu|
          pupu.file("config.rb").path
        end
      end

      def depends_on(plugin)
        # TODO
      end
    end
  end
end
