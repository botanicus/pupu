require "rubygems"
require "spec"
require "merb-core"
require "webrat"

Merb::Config.use do |config|
  config[:session_store] = "memory"
end

Merb.start_environment(testing: true, adapter: "runner", environment: "test")

Spec::Runner.configure do |config|
  #config.include(Merb::Test::ViewHelper)
  #config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::MakeRequest)
end
