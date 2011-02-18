# encoding: utf-8

require "pupu"
require "pupu/helpers"

Pupu.framework = :ace

# def Pupu.environment
#   Rails.environment
# end

# def Pupu.logger
#   Rails.logger
# end

Pupu.root = Dir.pwd
Pupu.media_root = File.join(Pupu.root, "content", "assets")
Ace::Helpers.send(:include, Pupu::Helpers)
