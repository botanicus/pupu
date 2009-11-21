require "pupu"
require "pupu/helpers"

Rango.after_boot(:register_pupu) do
  Pupu.root = Project.root
  Pupu.media_prefix = Project.settings.media_prefix
  Pupu.media_root = Project.settings.media_root
  Rango::Helpers.send(:include, Pupu::Helpers)
  Rango.logger.info("Pupu plugin registered")
end
