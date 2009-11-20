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

    # self.namespace = "pupu" # TODO: patch thor
    desc "install [*pupu]", "Install given pupu"
    def install(*pupus)
      CLI.install(*pupus)
    end

    desc "update [*pupu]", "Update given pupu if an argument given, otherwise update all pupus"
    def update(*pupus)
      CLI.update(*pupus)
    end

    desc "uninstall [*pupu]", "Uninstall given pupu"
    def uninstall(*pupus)
      CLI.uninstall(*pupus)
    end

    desc "list", "Show installed pupus"
    def list
      CLI.list
    end

    desc "search [pattern]", "Search remote pupus"
    def search(pattern = nil)
      CLI.search(pattern)
    end

    protected
    # Setup hook for tasks which require to have Pupu.root and Pupu.media_root set
    def setup
      load "config/pupu.rb"
    end
  end
end
