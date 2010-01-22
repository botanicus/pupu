# encoding: utf-8

require "pupu"
require "pupu/helpers"

Merb::BootLoader.before_app_loads do
  Pupu.root = Merb.root
  Pupu.media_root = File.join(Merb.root, "public")
  Merb::Controller.send(:include, Pupu::Helpers)
end
