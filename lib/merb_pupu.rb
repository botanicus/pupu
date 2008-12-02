# make sure we're running inside Merb
if defined?(Merb::Plugins)
  require "merb_pupu/helpers"
  Merb::Controller.send(:include, Merb::Plugins::PupuHelpersMixin)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:pupu] = {
    :root => ""
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
  end
  
  Merb::Plugins.add_rakefiles "merb_pupu/merbtasks"
end
