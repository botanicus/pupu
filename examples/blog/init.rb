#!/usr/bin/env ruby
# encoding: utf-8

require "rango"

# === Usage === #
# init.rb
# init.rb production
Rango.boot(environment: "development")

pupu_libdir = File.expand_path("../../lib")
raise Errno::ENOENT, "#{pupu_libdir} doesn't exist" unless File.directory?(pupu_libdir)
$:.unshift(pupu_libdir)

require_relative "config/pupu"

# if you will run this script with -i argument, interactive session will begin
Rango.interactive if ARGV.delete("-i")
