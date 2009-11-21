#!/usr/bin/env rackup -s thin -p 4000
# encoding: utf-8

require_relative "init"

require "rango"
require "rango/gv"
require "pupu/helpers"

Rango::Router.use(:usher)

# register helpers
Rango::GV::View.send(:include, Pupu::Helpers)

use Rango::Middlewares::Basic

Project.router = Usher::Interface.for(:rack) do
  get("/").to(Rango::GV.static {"index"})
  get("/examples/:template").to(Rango::GV.static { |template| "examples/#{template}" })
end

run Project.router
