require "pupu" # for version
require "pupu/pupu"
require "pupu/cli"

# Run rake pupu:install[mootools-core,mootools-more]
namespace :pupu do
  desc "Install given pupus"
  task :install do |task, args|
    CLI.install(*args)
  end

  desc "Uninstall given pupus"
  task :uninstall do |task, args|
    CLI.uninstall(*args)
  end

  desc "Update given pupus"
  task :update do |task, args|
    CLI.install(*args)
  end

  desc "List installed pupus"
  task :list do |task, args|
    CLI.list
  end

  # TODO: this isn't the right approach I guess
  namespace :tasks do
    desc "Update these tasks"
    task :selfupdate do
      taskfile = "#{Gem.dir}/gems/pupu-#{Pupu::VERSION}/tasks/pupu.thor"
      File.open(__FILE__, "w") do |file|
        puts "Taskfile updated"
        file.print(File.read(taskfile).chomp)
      end
    end
  end
end
