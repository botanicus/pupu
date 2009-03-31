require "pupu" # for version
require "pupu/pupu"
require "pupu/cli"

module Pupu
  class Tasks < Thor
    # self.namespace = "pupu" # TODO: patch thor
    desc "install [pupu(s)]", "Install given pupu(s)"
    def install(*pupus)
      CLI.install(*pupus)
    end

    desc "update [pupu(s)]", "Update installed pupus or update all if pupu(s) isn't given"
    def update(*pupus)
      CLI.update(*pupus)
    end

    desc "uninstall [pupu(s)]", "Uninstall given pupu(s)"
    def uninstall(*pupus)
      CLI.uninstall(*pupus)
    end

    alias_method :remove, :uninstall

    desc "list", "Show installed pupus"
    def list
      CLI.list
    end

    class Tasks < Thor
      desc "update", "Update local tasks"
      def update
        taskfile = "#{Gem.dir}/gems/pupu-#{Pupu::VERSION}/tasks/pupu.thor"
        File.open(__FILE__, "w") do |file|
          puts "Taskfile updated"
          file.print(File.read(taskfile).chomp)
        end
      end
    end
  end
end