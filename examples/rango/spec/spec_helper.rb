require_relative "../init"

require "spec"
require "webrat"
require "rack/test"

Rango::Utils.load_rackup

Spec::Runner.configure do |config|
  config.include Rack::Test::Methods

  def app
    Project.router
  end
end
