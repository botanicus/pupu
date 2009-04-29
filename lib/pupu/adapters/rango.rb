require "pupu"
require "pupu/helpers"

# TODO: Mixins::Controller instead of Controller ... or better helpers
Pupu.root = Project.root
Pupu.media_prefix = Project.settings.media_prefix
Pupu.media_root = Project.settings.media_root
Rango::Controller.send(:include, Pupu::PupuHelpersMixin)
Rango.logger.info("Pupu plugin registered")
