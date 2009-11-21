#!/usr/bin/env ruby
# encoding: utf-8

require "rango"
require "rango/gv"
require "pupu/helpers"

# === Usage === #
# init.rb
# init.rb production
Rango.boot(environment: "development")

pupu_libdir = File.expand_path("../../lib")
raise Errno::ENOENT, "#{pupu_libdir} doesn't exist" unless File.directory?(pupu_libdir)
$:.unshift(pupu_libdir)

# === Environment === #
Pupu.root = File.dirname(__FILE__)
Pupu.media_root = File.join(File.dirname(__FILE__), "media")

Rango::Router.use(:usher)

# register helpers
Rango::GV::View.send(:include, Pupu::Helpers)

Project.router = Usher::Interface.for(:rack) do
  get("/").to(Rango::GV.static {"index"})
  get("/examples/:template").to(Rango::GV.static { |template| "examples/#{template}" })
end

# if you will run this script with -i argument, interactive session will begin
Rango.interactive if ARGV.delete("-i")
