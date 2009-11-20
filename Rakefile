#!/usr/bin/env rake1.9
# encoding: utf-8

# http://support.runcoderun.com/faqs/builds/how-do-i-run-rake-with-trace-enabled
Rake.application.options.trace = true

task :setup => ["submodules:init"]

namespace :submodules do
  desc "Init submodules"
  task :init do
    sh "git submodule init"
  end

  desc "Update submodules"
  task :update do
    Dir["vendor/*"].each do |path|
      if File.directory?(path) && File.directory?(File.join(path, ".git"))
        Dir.chdir(path) do
          puts "=> #{path}"
          puts %x[git reset --hard]
          puts %x[git fetch]
          puts %x[git reset origin/master --hard]
          puts
        end
      end
    end
  end
end

task :gem do
  sh "gem build pupu.gemspec"
end

desc "Release new version of pupu"
task release: ["release:tag", "release:gemcutter"]

namespace :release do
  desc "Create Git tag"
  task :tag do
    require_relative "lib/pupu"
    puts "Creating new git tag #{Pupu::VERSION} and pushing it online ..."
    sh "git tag -a -m 'Version #{Pupu::VERSION}' #{Pupu::VERSION}"
    sh "git push --tags"
    puts "Tag #{Pupu::VERSION} was created and pushed to GitHub."
  end

  desc "Push gem to Gemcutter"
  task :gemcutter => :gem do
    puts "Pushing to Gemcutter ..."
    sh "gem push #{Dir["*.gem"].last}"
  end
end

desc "Run specs"
task :default => :setup do
  rubylib = (ENV["RUBYLIB"] || String.new).split(":")
  libdirs = Dir["vendor/*/lib"]
  ENV["RUBYLIB"] = (libdirs + rubylib).join(":")
  exec "./script/spec --options spec/spec.opts spec"
end
