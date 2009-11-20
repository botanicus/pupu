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

      def check
        # load || exit 1
      end

      def search(pattern) # search pattern or list all the available pupus if pattern is nil
        # search on github
        require "yaml"
        require "open-uri"
        open("http://github.com/api/v1/yaml/search/pupu") do |stream|
          repositories = YAML::load(stream.read)["repositories"]
          repositories.each do |repository|
            repository = OpenStruct.new(repository)
            if repository.name.match(/^pupu-/)
              if pattern.nil? || repository.name.match(pattern) # this is the convention, everything must start with pupu-
                # name, size, followers, username, language, fork, id, type, pushed, forks, description, score, created
                puts "[#{repository.username}/#{repository.name}] #{repository.description}#{" (fork)" if repository.fork}"
              end
            end
          end
        end
      end

      alias_method :remove, :uninstall
    end
  end
end
