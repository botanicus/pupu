#!/usr/bin/env ruby

$: << "lib"

require 'thor'
require "merb_pupu/pupu"
require "merb_pupu/cli"

module Merb
  class Pupu < Thor
    include Merb::Plugins
    desc "install [pupu(s)]", "Install given pupu(s)"
    def install(*pupus)
      CLI.install(pupus)
    end
    
    desc "update [pupu(s)]", "Update installed pupus or update all if pupu(s) isn't given"
    def update(*pupus)
      CLI.update(pupus)
    end
    
    desc "uninstall [pupu(s)]", "Uninstall given pupu(s)"
    def uninstall(*pupus)
      CLI.uninstall(pupus)
    end

    alias_method :remove, :uninstall
    
    desc "list", "Show installed pupus"
    def list
      CLI.list
    end
  end
end
