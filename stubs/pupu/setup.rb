# encoding: utf-8

require "simple-templater/hooks/preprocess/github"
require "simple-templater/hooks/preprocess/full_name"

# This hook will be executed before templater start to generate new files.
# It runs in context of current generator object.

# pupu create mootools --full-name="Jakub Stastny"
# --javascripts=mootools-core,mootools-more | --no-javascripts
# --stylesheets=one,two             | --no-stylesheets
# --dependencies=mootools,blueprint | --no-dependencies
# --ruby || --no-ruby
hook do |generator, context|
  generator.before Hooks::FullName, Hooks::GithubUser
  generator.target = "pupu-#{context[:name]}" unless generator.target.match(/^pupu-/) # this is the convention
  context[:javascripts] = [context[:name]] unless context.has_key?(:javascripts)
  context[:stylesheets] = [context[:name]] unless context.has_key?(:stylesheets)
  context[:javascripts]  ||= Array.new # will be used when --no-javascripts
  context[:stylesheets]  ||= Array.new
  context[:dependencies] ||= Array.new
  context[:github_repository] = generator.target
  unless context[:github_repository] && context[:github_repository].match(/^pupu-/)
    context[:github_repository] = "pupu-#{context[:github_repository]}"
  end
end
