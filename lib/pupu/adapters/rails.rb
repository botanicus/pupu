require "pupu"
require "pupu/helpers"

Pupu.root = Rails.root
Pupu.media_root = File.join(Rails.root, "public")
ActionView::Base.send(:include, Pupu::Helpers)
