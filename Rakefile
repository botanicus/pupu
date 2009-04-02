root = File.dirname(__FILE__)
$: << File.join(root, "lib")

require 'pupu'
require 'rake/gempackagetask'

GEM_NAME = "pupu"
GEM_VERSION = Pupu::VERSION
AUTHOR = "Jakub Stastny aka Botanicus"
EMAIL = "knava.bestvinensis(at)gmail.com"
HOMEPAGE = "http://101ideas.cz"
SUMMARY = "Pupu is a plugin system for media stuff like mootools plugins, icon sets etc. It knows dependencies and it has CLI interface, so it's really easy to bundle such pupus into your app."

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'pupu'
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('term-ansicolor')
  s.require_path = 'lib'
  s.files = %w(LICENSE README.textile Rakefile TODO Generators) + Dir.glob("{lib,spec,tasks}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
