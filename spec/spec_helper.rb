# encoding: utf-8

PROJECT_ROOT = File.join(File.dirname(__FILE__), "data")
PUPU_ROOT    = File.join(PROJECT_ROOT, "public")

require "pupu/pupu"
Pupu.root = PROJECT_ROOT
Pupu.media_root = PUPU_ROOT

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
