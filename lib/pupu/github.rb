require "fileutils"
require "yaml"
require "ostruct"
require "pupu/dsl"
require "pupu/metadata"
require "pupu/exceptions"

module ShellExtensions
  def run(command)
    puts "[bash] #{command}"
    %x(#{command})
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
          metadata = pupu.metadata # TODO: continue here @@@@@@@@@@@@@@@@@@@@@@@
          # TODO: check if is different revision on server (use GitHub API)
          FileUtils.rm_r(pupu.root)
          self.install_files(pupu_name, metadata.repozitory)
        else
          Pupu.all.each do |pupu_name|
            self.update(pupu_name)
          end
        end
      end

      # search for pupu
      def search(query)
        data = YAML::load("http://github.com/api/v1/yaml/search/pupu")
        data.map! { |result| OpenStruct.new(result) }
        data.select { |item| item.name.match(query) }
      end

      protected
      def save_metadata(url)
        revision = %x(git log | head -1).chomp.sub(/^commit /, "")
        dependencies = Array.new # TODO
        params = {:revision => revision, :repozitory => url, :dependencies => dependencies}
        Dir.chdir(@pupu.root) do
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
        chdir do |public_dir|
          raise PluginIsAlreadyInstalled if File.directory?(repo) # TODO: custom exception class
          run "git clone #{url} #{repo}"
          Dir.chdir(repo) do
            js_initializer = "initializers/#{repo}.js"
            css_initializer = "initializers/#{repo}.css"
            if File.exist?(js_initializer) &&  (not File.exist?("#{public_dir}/javascripts/initializers/#{repo}.js"))
              FileUtils.mkdir_p("#{public_dir}/javascripts/initializers")
              FileUtils.mv js_initializer,  "#{public_dir}/javascripts/initializers/#{repo}.js"
            end
            if File.exist?(css_initializer) && (not File.exist?("#{public_dir}/stylesheets/initializers/#{repo}.css"))
              FileUtils.mkdir_p("#{public_dir}/stylesheets/initializers")
              FileUtils.mv css_initializer,  "#{public_dir}/stylesheets/initializers/#{repo}.css"
            end
            @pupu = Pupu[repo]
            self.save_metadata(url)
            FileUtils.rm_r ".git"
          end
        end

      end

      def chdir(pupu = nil, &block)
        public_dir = File.join(Dir.pwd, "public")
        raise PublicDirNotExists unless File.directory?(public_dir) # TODO: create example class
        FileUtils.mkdir_p(Pupu.root) unless File.directory?(Pupu.root)
        Dir.chdir(Pupu.root) do
          pupu ? block.call(public_dir, pupu.root) : block.call(public_dir)
        end
      end
    end
  end
end
