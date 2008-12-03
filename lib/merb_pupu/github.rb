require "fileutils"
require "yaml"
require "ostruct"

module ShellExtensions
  def run(command)
    puts "[bash] #{command}"
    %x(#{command})
  end
end

module Merb
  module Plugins
    class GitHub
      class << self
        include ShellExtensions
        # GitHub.install("autocompleter")
        # GitHub.install("botanicus/autocompleter")
        def install(repo)
          user, repo = repo.split("/") if repo.match(%r{/})
          user = ENV["USER"] unless user
          url = "git://github.com/#{user}/pupu-#{repo}.git"
          chdir do |public_dir|
            raise "PluginIsAlreadyInstalled" if File.directory?(repo) # TODO: custom exception class
            run "git clone #{url} #{repo}"
            Dir.chdir(repo) do
              js_initializer = "initializers/#{repo}.js"
              css_initializer = "initializers/#{repo}.css"
              if File.exist?(js_initializer)
                FileUtils.mkdir_p("#{public_dir}/javascripts")
                FileUtils.mv js_initializer,  "#{public_dir}/javascripts/#{repo}.js"
              end
              if File.exist?(css_initializer)
                FileUtils.mkdir_p("#{public_dir}/stylesheets")
                FileUtils.mv css_initializer,  "#{public_dir}/stylesheets/#{repo}.css"
              end
              revision = %x(git log | head -1).chomp.sub(/^commit /, "")
              dependencies = Array.new # TODO
              @pupu = Pupu[repo]
              self.save_metadata(:revision => revision, :repozitory => url, :dependencies => dependencies)
              FileUtils.rm_r ".git"
            end
          end
          # TODO: git commit [files] -m "Added pupu #{repo} from #{url}"
        end

        def update(repo)
          if repo
            Pupu[repo].metadata
          else
            # update all
          end
        end

        # search for pupu
        def search(query)
          data = YAML::load("http://github.com/api/v1/yaml/search/pupu")
          data.map! { |result| OpenStruct.new(result) }
          data.select { |item| item.name.match(query) }
        end

        protected
        def save_metadata(params)
          Dir.chdir(@pupu.root) do
            File.open("metadata.yml", "w") do |file|
              file.puts(params.to_yaml)
            end
          end
        end

        def chdir(&block)
          public_dir = File.join(Dir.pwd, "public")
          raise "PublicDirNotExists" unless File.directory?(public_dir) # TODO: create example class
          FileUtils.mkdir_p(Pupu.root) unless File.directory?(Pupu.root)
          Dir.chdir(Pupu.root) do
            if @pupu
              block.call(public_dir, @pupu.root)
            else
              block.call(public_dir)
            end
          end
        end
      end
    end
  end
end
