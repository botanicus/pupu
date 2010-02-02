# encoding: utf-8

require "pupu"
require "pupu/helpers"

Pupu.framework = :rails

def Pupu.environment
  Rails.environment
end

def Pupu.logger
  Rails.logger
end

Pupu.root = Rails.root
Pupu.media_root = File.join(Rails.root, "public")
ActionView::Base.send(:include, Pupu::Helpers)
