#!/usr/bin/env gem1.9 build
# encoding: utf-8

# NOTE: we can't use require_relative because when we run gem build, it use eval for executing this file
$:.unshift File.join(File.dirname(__FILE__), "lib")
require "pupu/version"

Gem::Specification.new do |s|
  s.name = "pupu"
  s.version = Pupu::VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/pupu"
  s.summary = "Framework-agnostic package system for media files"
  s.description = "Pupu is a plugin system for media like mootools plugins, icon sets etc. It knows dependencies and it has CLI interface, so it's really easy to bundle such pupus into your app."
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")

  # files
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = ["pupu"]
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
