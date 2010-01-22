#!./script/nake
# encoding: utf-8

begin
  require_relative "gems/environment.rb"
rescue LoadError
  abort "You have to install bundler and run gem bundle first!"
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

ENV["PATH"] = "script:#{ENV["PATH"]}"

require "pupu/version"
require "nake/tasks/gem"
require "nake/tasks/spec"
require "nake/tasks/release"

begin
  load "code-cleaner.nake"
  Nake::Task["hooks:whitespace:install"].tap do |task|
    task.config[:path] = "script"
    task.config[:encoding] = "utf-8"
    task.config[:whitelist] = '(bin/[^/]+|.+\.(rb|rake|nake|thor|task))$'
  end
rescue LoadError
  warn "If you want to contribute to Pupu, please install code-cleaner and then run ./tasks.rb hooks:whitespace:install to get Git pre-commit hook for removing trailing whitespace."
end

# Setup encoding, so all the operations
# with strings from another files will work
Encoding.default_internal = "utf-8"
Encoding.default_external = "utf-8"

Task[:build].config[:gemspec] = "pupu.gemspec"
Task[:prerelease].config[:gemspec] = "pupu.pre.gemspec"
Task[:release].config[:name] = "pupu"
Task[:release].config[:version] = Pupu::VERSION
