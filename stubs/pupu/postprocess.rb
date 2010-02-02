# encoding: utf-8

require "simple-templater/hooks/postprocess/git_repository"

# This hook will be executed after templater finish in context of current generator object.
# Current directory is what you just generated, unless this is flat generator.

hook do |generator, context|
  # simple-templater create rango --full-name="Jakub Stastny"
  generator.after Hooks::GitRepository

  unless context[:ruby]
    rm "init.rb"
    rm "deps.rb"
    rm "#{context[:name]}.gemspec"
    rm "#{context[:name]}.pre.gemspec"
    rm_r "lib"
  end
end
