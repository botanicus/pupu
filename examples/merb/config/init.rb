# Go to http://wiki.merbivore.com/pages/init-rb

# bundler
begin
  require_relative "../gems/environment.rb"
rescue LoadError => exception
  abort "LoadError during loading gems/environment: #{exception.message}\nRun gem bundle to fix it."
end

# setup $:
pupu_libdir = File.expand_path("../../lib")
raise Errno::ENOENT, "#{pupu_libdir} doesn't exist" unless File.directory?(pupu_libdir)
$:.unshift(pupu_libdir)

require "pupu/adapters/merb"

use_orm :none
use_test :rspec
use_template_engine :erb

# Specify a specific version of a dependency
# dependency "RedCloth", "> 3.0"

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app"s classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app"s classes have been loaded.
end

# Move this to application.rb if you want it to be reloadable in dev mode.
Merb::Router.prepare do
  with(controller: "merb_example") do
    match("/").to(action: "index")
    match("/examples/:template").to(action: "static")
  end
end

Merb::Config.use do |config|
  config[:environment]         = "development",
  config[:framework]           = {},
  config[:log_level]           = :debug,
  config[:log_stream]          = STDOUT,
  # or use file for logging:
  # config[:log_file]          = Merb.root / "log" / "merb.log",
  config[:use_mutex]           = false,
  config[:session_store]       = "cookie",
  config[:session_id_key]      = "_merb_session_id",
  config[:session_secret_key]  = "55e74673c6b671fbcd32a405d9f41ab30fdc8ba3",
  config[:exception_details]   = true,
  config[:reload_classes]      = true,
  config[:reload_templates]    = true,
  config[:reload_time]         = 0.5
end
