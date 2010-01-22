#!/usr/bin/env gem1.9 build
# encoding: utf-8

require "base64"

Gem::Specification.new do |s|
  s.name = "pupu"
  s.version = "0.0.3"
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

  # RubyForge
  s.rubyforge_project = "pupu"
end
