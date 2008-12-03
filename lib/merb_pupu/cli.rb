require "fileutils"
require "yaml"
require "ostruct"
require "merb_pupu/github"

# copyied from merb.thor, this part is actually my code as well :)
module ColorfulMessages
  # red
  def error(*messages)
    puts messages.map { |msg| "\033[1;31m#{msg}\033[0m" }
  end
  
  # yellow
  def warning(*messages)
    puts messages.map { |msg| "\033[1;33m#{msg}\033[0m" }
  end
  
  # green
  def success(*messages)
    puts messages.map { |msg| "\033[1;32m#{msg}\033[0m" }
  end
  
  alias_method :message, :success
  
  # magenta
  def note(*messages)
    puts messages.map { |msg| "\033[1;35m#{msg}\033[0m" }
  end
  
  # blue
  def info(*messages)
    puts messages.map { |msg| "\033[1;34m#{msg}\033[0m" }
  end
end

module Merb
  module Plugins
    class CLI
      class << self
        include ColorfulMessages
        def install(argv)
          GitHub.install(*argv)
        end

        def uninstall(argv)
          argv.each do |item|
            Pupu[item].uninstall
          end
        end

        def update(args)
        end

        def list(argv)
          Pupu.root.entries.each do |item|
            puts(- "#{item}")
          end
        end

        alias_method :remove, :uninstall
      end
    end
  end
end
