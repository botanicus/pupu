# encoding: utf-8

require "fileutils"
require "yaml"
require "ostruct"
require "pupu/dsl"
require "pupu/metadata"
require "pupu/exceptions"

module ShellExtensions
  def run(command)
    puts "[SHELL] #{command} # in #{Dir.pwd}"
    %x(#{command})
    $?.exitstatus == 0
  end
end

# TODO: standalone installer class
module Pupu
  class GitHub
    class << self
      include ShellExtensions
      # GitHub.install("autocompleter")
      # GitHub.install("botanicus/autocompleter", force: true)
      def install(repo, options = Hash.new)
        user, repo = repo.split("/") if repo.match(%r{/})
        user = ENV["USER"] unless user
        url = "git://github.com/#{user}/pupu-#{repo}.git"
        info "Installing #{repo}"
        self.install_files(repo, url, options)
        self.install_dependencies(@pupu, options)
        # TODO: git commit [files] -m "Added pupu #{repo} from #{url}"
      end

      def update(pupu_name)
        if pupu_name
          pupu = Pupu[pupu_name]
          if ::Pupu.strategy.eql?(:submodules)
            puts %(git fetch)
            puts %(git reset origin/master --hard)
          else
            path = pupu.root.to_s # otherwise after we remove the path, we get error at mkdir telling us that the path doesn't exist
            pupu.metadata # cache metadata
            FileUtils.rm_r(path)
            self.install_files(pupu_name, pupu.metadata.repository)
          end
        else
          Pupu.all.each do |pupu_name|
            self.update(pupu_name)
          end
        end
        pupu.metadata.dependencies.each do |dependency|
          self.update(dependency)
        end
      end

      # search for pupu
      def search(query)
        data = YAML::load("http://github.com/api/v1/yaml/search/pupu")
        data.map! { |result| OpenStruct.new(result) }
        data.select { |item| item.name.match(query) }
      end

      protected
      def save_metadata(pupu, url)
        revision = %x(git log --pretty=format:'%H' -1)
        dsl = DSL.new(pupu)
        dependencies = dsl.get_dependencies.map { |dependency| dependency.name }
        params = {revision: revision, repository: url, dependencies: dependencies}
        Dir.chdir(@pupu.root.to_s) do
          File.open("metadata.yml", "w") do |file|
            file.puts(params.to_yaml)
          end
        end
      end

      def install_dependencies(pupu, options = Hash.new)
        dsl = DSL.new(pupu)
        dsl.instance_eval(File.read(pupu.file("config.rb").path))
        dsl.get_dependencies.each do |dependency|
          begin
            info "Installing dependency #{dependency}"
            self.install(dependency.name.to_s, options) # FIXME: "user/repo"
          rescue PluginIsAlreadyInstalled => exception
            puts "~ #{exception.message}"
          end
        end
      end

      def install_files(repo, url, options = Hash.new)
        chdir do |media_dir|
          if File.directory?(repo) && !options[:force]
            raise PluginIsAlreadyInstalled, "Pupu #{repo} already exist"
          elsif File.directory?(repo) && options[:force]
            FileUtils.rm_r(repo)
          end
          run("git clone #{url} #{repo}") || abort("Git failed")
          Dir.chdir(repo) do
            proceed_files(repo, url)
          end
        end
      end

      def proceed_files(repo, url)
        @pupu = Pupu[repo]
        @pupu.copy_initializers
        self.save_metadata(@pupu, url)
        FileUtils.rm_r(".git") if ::Pupu.strategy.eql?(:copy)
      rescue Exception => exception
        FileUtils.rm_r(repo) if File.directory?(repo)
        raise exception
      end

      def chdir(pupu = nil, &block)
        FileUtils.mkdir_p(Pupu.root_path) unless File.directory?(Pupu.root_path)
        Dir.chdir(Pupu.root_path.to_s) do
          pupu ? block.call(pupu.root) : block.call(Pupu.root_path)
        end
      end
    end
  end
end
