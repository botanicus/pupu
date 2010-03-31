# encoding: utf-8

require "pupu/dsl"
require "pupu/pupu"

module Pupu
  class Page
    attr_reader :files
    def initialize
      @files = Array.new
    end

    def parse(name, options)
      Parser.new(name, options, self)
    end
  end

  class Parser
    def initialize(plugin_name, plugin_params, page = Page.new)
      @plugin    = Pupu[plugin_name, plugin_params]
      @output    = Array.new
      puts "Parser: #{page.inspect}"
      @page = page
      @dsl       = DSL.new(@plugin, page)
      @@loaded ||= Hash.new
      @@loaded[@plugin.name] = Array.new
    end

    def loaded?
      # The reason why just array with plugin names isn't enough is that every time it can be called
      # with different parameters. For example pupu :mootools and then pupu :mootools, more: true
      @@loaded[@plugin.name] && @dsl.files.all? do |file|
        @@loaded[@plugin.name].include?(file)
      end

      false # FIXME: there is a bug in this method, it returns true in every case (not so important)
    end

    def add_initializers
      js_initializer  = @plugin.initializer(:javascript)
      css_initializer = @plugin.initializer(:stylesheet)
      @output.push("\n<link href='#{css_initializer.url}' media='screen' rel='stylesheet' type='text/css' />") if css_initializer
      @output.push("\n<script src='#{js_initializer.url}' type='text/javascript'></script>") if js_initializer
    end

    def add_dependencies
      @dsl.get_dependencies.each do |dependency|
        parser = Parser.new(dependency.name, dependency.params, @page)
        @output.push(parser.parse!) unless parser.loaded?
      end
    end

    def parse!
      @dsl.instance_eval(File.read(@plugin.file("config.rb").path))
      self.add_dependencies
      @@loaded[@plugin.name].push(*@dsl.files)
      @output.push(@dsl.output)
      self.add_initializers
      return @output.join("\n")
    end
  end
end
