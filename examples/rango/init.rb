#!/usr/bin/env ruby
# encoding: utf-8

# === Usage === #
# init.rb

# setup $:
pupu_libdir = File.expand_path("../../lib")
raise Errno::ENOENT, "#{pupu_libdir} doesn't exist" unless File.directory?(pupu_libdir)
$:.unshift(pupu_libdir)

# load and boot rango
require "rango"
require "pupu/adapters/rango" # this has to be loaded before rango boot

Rango.boot

# if you will run this script with -i argument, interactive session will begin
Rango.interactive if ARGV.delete("-i")
