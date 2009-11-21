require "pupu/helpers"

Merb::Controller.send(:include, Pupu::Helpers)

Merb::Plugins.config[:pupu] = {
  :root => ""
}

Merb::BootLoader.before_app_loads do
  # require code that must be loaded before the application
end

Merb::BootLoader.after_app_loads do
end
