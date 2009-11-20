require "fileutils"
require "yaml"
require "ostruct"
require "media-path"
require "pupu"
require "pupu/github"

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

module Pupu
  class CLI
    class << self
      include ColorfulMessages
      def install(*args)
        args.each do |pupu|
          begin
            GitHub.install(pupu)
          rescue PluginIsAlreadyInstalled
            error "Plugin #{pupu} is already installed, skipping ..."
            next
          end
        end
      end

      def uninstall(*args)
        args.each do |pupu|
          #begin
            Pupu[pupu].uninstall
          #rescue
            #error ""
            #next
          #end
        end
      end

      def update(*args)
        args.each do |pupu|
          begin
            GitHub.update(pupu)
          rescue PluginNotFoundError
            error "Plugin not found: #{pupu}"
            next
          end
        end
      end

      def list
        entries = Dir["#{Pupu.root}/*"].select { |entry| File.directory?(entry) }
        if File.exist?(Pupu.root) and not entries.empty?
          puts entries.map { |item| "- #{File.basename(item)}" }
        else
          error "Any pupu isn't installed yet."
        end
      end

      alias_method :remove, :uninstall
    end
  end
end
