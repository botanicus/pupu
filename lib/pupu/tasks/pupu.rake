# encoding: utf-8

# == How Rake Works with Arguments ==
# http://rubyforge.org/pipermail/rake-devel/2007-December/000352.html

# == Setup ==
# task "pupu:setup" => :environment
namespace :pupu do
  task :load do
    require "pupu/cli"
  end

  desc "Setup hook for tasks which require to have Pupu.root and Pupu.media_root set"
  task setup: "pupu:load"

  # Run rake pupu:install[mootools-core,mootools-more]
  desc "Install pupu"
  task :install, [:name] => "pupu:setup" do |task, args|
    Pupu::CLI.install(args.name)
  end

  desc "Uninstall given pupu"
  task :uninstall, [:name] => "pupu:setup" do |task, args|
    Pupu::CLI.uninstall(args.name)
  end

  desc "Update given pupu if an argument given, otherwise update all pupus"
  task :update, [:name] => "pupu:setup" do |task, args|
    args = [args.name] ? args.name : Array.new
    Pupu::CLI.update(*args)
  end

  desc "List all installed pupus"
  task list: "pupu:setup" do
    Pupu::CLI.list
  end

  desc "Search pupu matching given pattern on GitHub"
  task :search, [:pattern] => "pupu:load" do |task, args|
    Pupu::CLI.search(args.pattern)
  end
end
