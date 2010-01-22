require "fileutils"
require "yaml"
require "ostruct"
require "pupu/dsl"
require "pupu/metadata"
require "pupu/exceptions"

module ShellExtensions
  def run(command)
    puts "[SHELL] #{command}"
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
      # GitHub.install("botanicus/autocompleter")
      def install(repo)
        user, repo = repo.split("/") if repo.match(%r{/})
        user = ENV["USER"] unless user
        url = "git://github.com/#{user}/pupu-#{repo}.git"
        self.install_files(repo, url)
        self.install_dependencies(@pupu)
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
            self.install_files(pupu_name, pupu.metadata.repozitory)
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
        revision = %x(git log | head -1).chomp.sub(/^commit /, "")
        dsl = DSL.new(pupu)
        dependencies = dsl.get_dependencies.map { |dependency| dependency.name }
        params = {revision: revision, repozitory: url, dependencies: dependencies}
        Dir.chdir(@pupu.root.to_s) do
          File.open("metadata.yml", "w") do |file|
            file.puts(params.to_yaml)
          end
        end
      end

      def install_dependencies(pupu)
        dsl = DSL.new(pupu)
        dsl.instance_eval(File.read(pupu.file("config.rb").path))
        dsl.get_dependencies.each do |dependency|
          self.install(dependency.name.to_s) # FIXME: "user/repo"
        end
      end

      def install_files(repo, url)
        chdir do |media_dir|
          raise PluginIsAlreadyInstalled if File.directory?(repo) # TODO: custom exception class
          run("git clone #{url} #{repo}") || abort("Git failed")
          Dir.chdir(repo) do
            proceed_files(repo, url)
          end
        end
      end

      def proceed_files(repo, url)
        js_initializer = "initializers/#{repo}.js"
        css_initializer = "initializers/#{repo}.css"
        if File.exist?(js_initializer) &&  (not File.exist?("#{::Pupu.media_root}/javascripts/initializers/#{repo}.js"))
          puts "Creating JS initializer"
          FileUtils.mkdir_p("#{::Pupu.media_root}/javascripts/initializers")
          FileUtils.mv js_initializer, "#{::Pupu.media_root}/javascripts/initializers/#{repo}.js"
        end
        if File.exist?(css_initializer) && (not File.exist?("#{::Pupu.media_root}/stylesheets/initializers/#{repo}.css"))
          puts "Creating CSS initializer"
          FileUtils.mkdir_p("#{::Pupu.media_root}/stylesheets/initializers")
          FileUtils.mv css_initializer, "#{::Pupu.media_root}/stylesheets/initializers/#{repo}.css"
        end
        @pupu = Pupu[repo]
        self.save_metadata(@pupu, url)
        FileUtils.rm_r(".git") if ::Pupu.strategy.eql?(:copy)
      rescue Exception => exception
        FileUtils.rm_r(repo) if File.directory?(repo)
        raise exception
      end

      def chdir(pupu = nil, &block)
        FileUtils.mkdir_p(Pupu.root_path) unless File.directory?(Pupu.root_path)
        Dir.chdir(Pupu.root.to_s) do
          pupu ? block.call(pupu.root) : block.call(Pupu.root)
        end
      end
    end
  end
end
