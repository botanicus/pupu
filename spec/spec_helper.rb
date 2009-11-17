# encoding: utf-8

PUPU_ROOT = File.join(File.dirname(__FILE__), "data", "public")

require "pupu/pupu"
Pupu.media_root = PUPU_ROOT

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
