# encoding: utf-8

require "pupu"
require "pupu/helpers"

Pupu.framework = :rango

def Pupu.environment
  Rango.environment
end

def Pupu.logger
  Rango.logger
end

Rango.after_boot(:register_pupu) do
  Pupu.root = Rango.root
  #Pupu.media_prefix = Project.settings.media_prefix
  #Pupu.media_root = Project.settings.media_root
  Rango::Helpers.send(:include, Pupu::Helpers)
  Rango.logger.info("Pupu plugin registered")
end

module Pupu
  module Helpers
    def pupu_page
      # page = get_context_value(:page) # TOHLE KUNDA NEFUNGUJE V TEMPLEJTACH :(
      # set_context_value(:page, page || Page.new)
      context[:pupu_page] ||= Page.new
    end
  end
end
