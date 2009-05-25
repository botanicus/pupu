begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

VERSION  = "0.0.1"
SPECIFICATION = ::Gem::Specification.new do |s|
  s.name = "pupu"
  s.version = VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/pupu"
  s.summary = "Framework-agnostic package system for media files"
  s.description = "Pupu is a plugin system for media like mootools plugins, icon sets etc. It knows dependencies and it has CLI interface, so it's really easy to bundle such pupus into your app."
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  # s.executables = ["rango"]
  # s.default_executable = "rango"
  s.require_paths = ["lib"]
  # s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
  s.rubyforge_project = "pupu"
end
