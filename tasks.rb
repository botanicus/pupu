#!./script/nake
#!./script/nake
# encoding: utf-8
# encoding: utf-8


begin
begin
  require_relative "gems/environment.rb"
  require_relative "gems/environment.rb"
rescue LoadError
rescue LoadError
  abort "You have to install bundler and run gem bundle first!"
  abort "You have to install bundler and run gem bundle first!"
end
end


ENV["PATH"] = "script:#{ENV["PATH"]}"
ENV["PATH"] = "script:#{ENV["PATH"]}"


require "nake/tasks/gem"
require "nake/tasks/gem"
require "nake/tasks/spec"
require "nake/tasks/spec"
require "nake/tasks/release"
require "nake/tasks/release"


load "code-cleaner.nake"
load "code-cleaner.nake"


unless File.exist?(".git/hooks/pre-commit")
unless File.exist?(".git/hooks/pre-commit")
  warn "If you want to contribute to Pupu, please run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace"
  warn "If you want to contribute to SimpleTemplater, please run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace"
end
end


require_relative "lib/pupu"
require_relative "lib/simple-templater"


# Setup encoding, so all the operations
# Setup encoding, so all the operations
# with strings from another files will work
# with strings from another files will work
Encoding.default_internal = "utf-8"
Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"
Encoding.default_external = "utf-8"


Task[:build].config[:gemspec] = "pupu.gemspec"
Task[:build].config[:gemspec] = "simple-templater.gemspec"
Task[:prerelease].config[:gemspec] = "pupu.pre.gemspec"
Task[:prerelease].config[:gemspec] = "simple-templater.pre.gemspec"
Task[:release].config[:name] = "pupu"
Task[:release].config[:name] = "simple-templater"
Task[:release].config[:version] = Pupu::VERSION
Task[:release].config[:version] = SimpleTemplater::VERSION


Nake::Task["hooks:whitespace:install"].tap do |task|
Nake::Task["hooks:whitespace:install"].tap do |task|
  task.config[:path] = "script"
  task.config[:path] = "script"
  task.config[:encoding] = "utf-8"
  task.config[:encoding] = "utf-8"
  task.config[:whitelist] = '(bin/[^/]+|.+\.(rb|rake|nake|thor|task))$'
  task.config[:whitelist] = '(bin/[^/]+|.+\.(rb|rake|nake|thor|task))$'
end
end
