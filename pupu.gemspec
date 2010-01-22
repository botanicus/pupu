#!/usr/bin/env gem build
# encoding: utf-8

require "base64"
require File.join(File.dirname(__FILE__), "lib/pupu/version")

Gem::Specification.new do |s|
  s.name = "pupu"
  s.version = Pupu::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/pupu"
  s.summary = "Framework-agnostic package system for media files"
  s.description = "Pupu is a plugin system for media like mootools plugins, icon sets etc. It knows dependencies and it has CLI interface, so it's really easy to bundle such pupus into your app."
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")

  # files
  s.files = `git ls-files`.split("\n")

  s.executables = Dir["bin/*"].map(&File.method(:basename))
  s.default_executable = "pupu"
  s.require_paths = ["lib"]

  # Ruby version
  s.required_ruby_version = ::Gem::Requirement.new("~> 1.9.1")

  # runtime dependencies
  s.add_dependency "media-path"

  # development dependencies
  # use gem install pupu --development if you want to install them
  s.add_development_dependency "simple-templater"

  begin
    require "changelog"
  rescue LoadError
    warn "You have to have changelog gem installed for post install message"
  else
    s.post_install_message = CHANGELOG.new.version_changes
  end

  # RubyForge
  s.rubyforge_project = "pupu"
end
