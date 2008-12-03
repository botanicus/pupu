require "fileutils"
require "yaml"

module Merb
  module Plugins
    class GitHub
      class << self
        # GitHub.install("autocompleter")
        # GitHub.install("botanicus/autocompleter")
        def install(repo)
          user, repo = repo.split("/") if repo.match(%r{/})
          user = ENV["USER"] unless defined?(user)
          url = "git://github.com/#{user}/pupu-#{repo}.git"
          chdir do |public_dir, repo_dir|
            puts %x(git clone #{url})
            Dir.chdir(repo_dir) do
              FileUtils.mv "initializers/#{repo}.js",  "#{public_dir}/javascripts/#{repo}.js"
              FileUtils.mv "initializers/#{repo}.css", "#{public_dir}/stylesheets/#{repo}.css"
              revision = "git log | head -1".chomp.sub(/^commit /, "")
              dependencies = Array.new # TODO
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

        protected
        def save_metadata(params)
          Dir.chdir(@plugin.root) do
            File.open("metadata.yml", "w") do |file|
              file.puts(params.to_yaml)
            end
          end
        end

        def chdir(&block)
          public_dir = File.join(Dir.pwd, "public")
          Dir.chdir(Pupu.root) do
            block.call(public_dir, repo_dir)
          end
        end
      end
    end
  end
end
