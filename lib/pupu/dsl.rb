require "ostruct"
require "path"

class Hash
  def to_html_attrs
    self.map { |key, value| "#{key}='#{value}'" }.join(" ")
  end
end

module Pupu
  class DSL
    attr_reader :output, :files
    def initialize(plugin)
      @plugin = plugin
      @output = Array.new
      @files  = Array.new
      @dependencies = Array.new
    end

    def dependency(pupu, params = Hash.new)
      struct = OpenStruct.new
      struct.name = pupu
      struct.params = params
      @dependencies.push(struct)
    end

    def dependencies(*pupus)
      pupus.each do |pupu|
        self.dependency(pupu)
      end
    end

    def get_dependencies
      @dependencies
    end

    def javascript(basename, params = Hash.new)
      path = @plugin.javascript(basename).url
      tag  = "<script src='#{path}' type='text/javascript'></script>"
      @files.push(path)
      @output.push(tag)
    end

    def stylesheet(basename, params = Hash.new)
      path = @plugin.stylesheet(basename).url
      default = {media: 'screen', rel: 'stylesheet', type: 'text/css'}
      params = default.merge(params)
      tag  = "<link href='#{path}' #{params.to_html_attrs} />"
      @files.push(path)
      @output.push(tag)
    end

    def javascripts(*names)
      names.each do |name|
        self.javascript(name)
      end
    end

    def stylesheets(*names)
      names.each do |name|
        self.stylesheet(name)
      end
    end

    # parameter :type, :optional => ["local", "request"] do |type|
    #   javascript "autocompleter.#{type}"
    # end

    # parameter :more do |boolean|
    #  javascript "mootools-1.2-more" if boolean
    # end
    def parameter(name, params = Hash.new, &block)
      # pupu :autocompleter, :type => "request"
      # @plugin.params: { :type => "request" }
      
      # pupu :mootools, :more => true
      # @plugin.params: { :more => true }
      if @plugin.params.key?(name)
        block.call(@plugin.params[name])
      end
    end
  end
end
