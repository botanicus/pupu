module Merb
  module Pupu
    class Metadata
      class << self
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
end
