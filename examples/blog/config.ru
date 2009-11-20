#!/usr/bin/env rackup -s thin -p 4000
# encoding: utf-8

require_relative "init"

require "rango"
require "pupu/helpers"
require "rango/generic_views"

Rango::Router.use(:usher)

# register helpers
Rango::GV.extend(Pupu::PupuHelpersMixin)

use Rack::Static, :urls => ["/javascripts", "/pupu"], :root => "media"

Project.router = Usher::Interface.for(:rack) do
  get("/").to(Rango::GV.static("index"))
  get("/examples/:template").to(Rango::GV.static)
end

run Project.router
