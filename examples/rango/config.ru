#!/usr/bin/env rackup -s thin -p 4000
# encoding: utf-8

require_relative "init"

use Rango::Middlewares::Basic
run Project.router
