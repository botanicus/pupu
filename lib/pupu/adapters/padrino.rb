# encoding: utf-8

require "pupu"
require "pupu/helpers"

# class MyApp < Padrino::Application
#   register Pupu::Helpers
# end

module Pupu::Helpers
  def self.registered(app)
    app.send(:include, self)
  end
end

Pupu.framework = :padrino

def Pupu.environment
  Padrino.environment
end

def Pupu.logger
  Padrino.logger
end

Pupu.root = Padrino.root
Pupu.media_root = File.join(Padrino.root, "public")
