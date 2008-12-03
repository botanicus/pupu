namespace :git do
  desc "Do the initial import"
  task :init do
    sh "git init"
    sh "git add ."
    sh "git commit -a -m 'Initial import'"
  end
end

namespace :github do
  desc "Do the initial import"
  task :create do
    user = ENV["USER"]
    repo = "pupu-<%= name %>" # TODO: add the Rakefile as erb template
  end
end

namespace :javascripts do
  desc "Compress javascripts"
  task :compress do
    puts "This task isn't ready yet."
  end
end

namespace :stylesheets do
  desc "Compress stylesheets"
  task :compress do
    puts "This task isn't ready yet."
  end
end

namespace :sass do
  desc "Compile Sass templates"
  task :compile do
    puts "This task isn't ready yet."
  end
end
