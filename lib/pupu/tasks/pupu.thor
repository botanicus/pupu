# encoding: utf-8

# Pupu::Tasks.class_eval do
#   def setup
#     load "config/environment.rb"
#   end
# end

module Pupu
  class Tasks < Thor
    def initialize
      require "pupu/cli"
      self.setup
    end

    # you may want to redefine this method
    def setup
      load "config/pupu.rb"
    end

    # self.namespace = "pupu" # TODO: patch thor
    desc "install [*pupu]", "Install given pupu(s)"
    def install(*pupus)
      CLI.install(*pupus)
    end

    desc "update [*pupu]", "Update installed pupus or update all if pupu(s) isn't given"
    def update(*pupus)
      CLI.update(*pupus)
    end

    desc "uninstall [*pupu]", "Uninstall given pupu(s)"
    def uninstall(*pupus)
      CLI.uninstall(*pupus)
    end

    desc "list", "Show installed pupus"
    def list
      CLI.list
    end

    desc "search", "Search remote pupus"
    def search(pattern = nil)
      CLI.search(pattern)
    end
  end
end
